//
//  EWCStrokeInputView.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EWCStrokeInputView.h"
#import "EWCPathProcessor.h"
#import "EWCCurveFitter.h"

@interface EWCStrokeInputView ()

@end

typedef NSArray<NSValue *> EWCPoints;

//static void dumpPoints(EWCPoints *points) {
//  int numPoints = (int)points.count;
//  for (int i = 0; i < numPoints; ++i) {
//    CGPoint p = points[i].CGPointValue;
//    NSLog(@"[%d]:(%g, %g)", i, p.x, p.y);
//  }
//}

@implementation EWCStrokeInputView {
  NSMutableArray<NSValue *> *_currentPoints;
  NSMutableArray<EWCPoints *> *_curves;
  BOOL _touching;
  CAShapeLayer *_currentStrokeLayer;
  CAShapeLayer *_curveLayer;
  double _epsilon;
  EWCPathProcessor *_pathProcessor;
  EWCCurveFitter *_curveFitter;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self initInternal];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initInternal];
  }
  return self;
}

- (void)initInternal {
  _touching = NO;
  _epsilon = 5.0 / 400.0 * self.bounds.size.width;
//  _epsilon = 1;
  _pathProcessor = [EWCPathProcessor new];
  _curveFitter = [EWCCurveFitter new];
  _curves = [NSMutableArray<EWCPoints *> new];

//  _currentPoints = [NSMutableArray<NSValue *> arrayWithObjects:
//    [NSValue valueWithCGPoint:CGPointMake(100, 100)],
//    [NSValue valueWithCGPoint:CGPointMake(200, 100)],
//    [NSValue valueWithCGPoint:CGPointMake(200, 200)],
//    nil];
//  [self completeCurrentPoints];
}

-(CGPoint)simplifyTouches:(NSSet<UITouch *> *)touches {
  UITouch *touch = touches.anyObject;
  if (touch) {
    return [touch locationInView:self];
  }

  return CGPointMake(-1, -1);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

  _currentPoints = [NSMutableArray<NSValue *> new];
  CGPoint point = [self simplifyTouches:touches];
  if (point.x < 0) { return; }

  [_currentPoints addObject:[NSValue valueWithCGPoint:point]];
  _touching = YES;

  [self drawCurrentPoints];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (! _touching) { return; }

  CGPoint point = [self simplifyTouches:touches];
  if (point.x < 0) { return; }

  [_currentPoints addObject:[NSValue valueWithCGPoint:point]];
  [self resetCurrentStrokeLayer];
  [self drawCurrentPoints];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (! _touching) { return; }

  CGPoint point = [self simplifyTouches:touches];
  if (point.x < 0) { return; }

  [_currentPoints addObject:[NSValue valueWithCGPoint:point]];
  [self completeCurrentPoints];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  _currentPoints = [NSMutableArray<NSValue *> new];
  _touching = NO;
}

- (void)resetCurrentStrokeLayer {
  _currentStrokeLayer = [self resetLayer:_currentStrokeLayer];
}

- (void)drawCurrentPoints {
  if (_currentPoints.count < 1) { return; }

  UIBezierPath *path = [UIBezierPath new];
  int numPoints = (int)_currentPoints.count;

  CGPoint lastPoint = [_currentPoints[0] CGPointValue];
  [path moveToPoint:lastPoint];

  for (int i = 1; i < numPoints; ++i) {
    NSValue *pointValue = _currentPoints[i];
    CGPoint p = [pointValue CGPointValue];

    [path addLineToPoint:p];
  }

  [_currentStrokeLayer setPath:path.CGPath];
}

- (void)completeCurrentPoints {
//  NSLog(@"%@", @"Raw Points:");
//  dumpPoints(_currentPoints);
  NSArray<NSValue *> *simplifiedPoints =
    [_pathProcessor douglasPeuckerSimplifyPoints:_currentPoints epsilon:_epsilon];

//  NSLog(@"%@", @"Simplified Points:");
//  dumpPoints(simplifiedPoints);
  NSArray<NSValue *> *curvePoints =
    [_curveFitter fitCurveToPoints:simplifiedPoints];

  if (curvePoints) {
//    NSLog(@"%@", @"Curve Points:");
//    dumpPoints(curvePoints);
//  NSLog(@"c:%ld", curvePoints.count);
    [_curves addObject:curvePoints];
  }

  [self updateCurveLayer];
  [self resetCurrentStrokeLayer];
}

- (void)updateCurveLayer {
  [self resetCurveLayer];
  [self drawCurves];
}

//- (void)addCurveToPath:(EWCPoints *)curve path:(UIBezierPath *)path {
//  int numPoints = (int)curve.count;
//
//  CGPoint lastPoint = [curve[0] CGPointValue];
//  [path moveToPoint:lastPoint];
//
//  for (int i = 1; i < numPoints; ++i) {
//    NSValue *pointValue = curve[i];
//    CGPoint p = [pointValue CGPointValue];
//
//    [path addLineToPoint:p];
//  }
//}

- (void)addCurveToPath:(EWCPoints *)curve path:(UIBezierPath *)path {
  int numPoints = (int)curve.count;

  [path moveToPoint:curve[0].CGPointValue];

  for (int i = 1; i < numPoints; i += 3) {
    CGPoint cp0 = curve[i].CGPointValue;
    CGPoint cp1 = curve[i + 1].CGPointValue;
    CGPoint p1 = curve[i + 2].CGPointValue;

    [path addCurveToPoint:p1 controlPoint1:cp0 controlPoint2:cp1];
  }
}

- (void)drawCurves {
  if (_curves.count == 0) { return; }

  UIBezierPath *path = [UIBezierPath new];

  for (EWCPoints *curve in _curves) {
    if (curve.count < 1) { continue; }
    [self addCurveToPath:curve path:path];
  }

  [_curveLayer setPath:path.CGPath];
}

- (void)resetCurveLayer {
  _curveLayer = [self resetLayer:_curveLayer];
}

- (CAShapeLayer *)resetLayer:(CAShapeLayer *)layer {
  if (layer) {
    [layer removeFromSuperlayer];
  }

  layer = [CAShapeLayer new];
  layer.lineWidth = (3 / 109.0) * self.bounds.size.width;
  layer.lineCap = kCALineCapRound;
  layer.lineJoin = kCALineJoinRound;
  layer.strokeColor = [UIColor blackColor].CGColor;
  layer.fillColor = nil;

  [self.layer addSublayer:layer];
  return layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
