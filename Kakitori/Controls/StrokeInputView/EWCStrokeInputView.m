//
//  EWCStrokeInputView.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EWCStrokeInputView.h"

@interface EWCStrokeInputView ()

@end

typedef NSArray<NSValue *> EWCPoints;

@implementation EWCStrokeInputView {
  NSMutableArray<NSValue *> *_currentPoints;
  NSMutableArray<EWCPoints *> *_curves;
  BOOL _touching;
  CAShapeLayer *_currentStrokeLayer;
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
  [self startCurrentStrokeLayer];
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

- (void)startCurrentStrokeLayer {
  if (_currentStrokeLayer) {
    [_currentStrokeLayer removeFromSuperlayer];
  }

  _currentStrokeLayer = [CAShapeLayer new];
  _currentStrokeLayer.lineWidth = (3 / 109.0) * self.bounds.size.width;
  _currentStrokeLayer.lineCap = kCALineCapRound;
  _currentStrokeLayer.lineJoin = kCALineJoinRound;
  _currentStrokeLayer.strokeColor = [UIColor blackColor].CGColor;
  _currentStrokeLayer.fillColor = nil;

  [self.layer addSublayer:_currentStrokeLayer];
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

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
