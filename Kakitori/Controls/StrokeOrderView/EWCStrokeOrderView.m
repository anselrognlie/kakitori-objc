//
//  EWCStrokeOrderView.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeOrderView.h"
#import "EWCStrokeData.h"
#import "EWCStroke.h"
#import "EWCStrokePart.h"

#import "EWCStrokeCapStyleConverter.h"
#import "EWCStrokeJoinStyleConverter.h"

IB_DESIGNABLE

const char kStrokeEndKey[] = "strokeEnd";
const char kAnimationName[] = "stroke";

@implementation EWCStrokeOrderView {
  EWCStrokeCapStyleConverter *_capStyleConverter;
  EWCStrokeJoinStyleConverter *_joinStyleConverter;
  BOOL _needsLayout;
  NSArray<CAShapeLayer *> *_strokeLayers;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    self = [self initInternal];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self = [self initInternal];
  }
  return self;
}

- (instancetype)initInternal {
  _capStyleConverter = [EWCStrokeCapStyleConverter new];
  _joinStyleConverter = [EWCStrokeJoinStyleConverter new];
  _needsLayout = YES;
  return self;
}

- (void)setStrokeData:(EWCStrokeData *)data {
  _strokeData = data;
  _needsLayout = YES;
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  if (! _needsLayout) { return; }
  if (! _strokeData) { return; }

  _needsLayout = NO;

  NSMutableArray<CAShapeLayer *> *layers = [NSMutableArray<CAShapeLayer *> new];

  CGRect bounds = self.bounds;
  CGFloat ox = bounds.origin.x;
  CGFloat oy = bounds.origin.y;
  CGFloat vx = _strokeData.viewLeft;
  CGFloat vy = _strokeData.viewTop;

  CGFloat sx = bounds.size.width / (_strokeData.viewRight - vx);
  CGFloat sy = bounds.size.height / (_strokeData.viewBottom - vy);

  CGAffineTransform t = CGAffineTransformMakeTranslation(-vx, -vy);
  t = CGAffineTransformScale(t, sx, sy);
  t = CGAffineTransformTranslate(t, ox, oy);

  NSArray<UIBezierPath *> *paths = [_strokeData convertToPoints];
  for (UIBezierPath *path in paths) {
    [path applyTransform:t];

    // create a child layer to hold the path
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.path = path.CGPath;
    layer.strokeStart = 0;
    layer.strokeEnd = 1.0;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = nil;
    layer.lineWidth = _strokeData.strokeWidth * sx;
    layer.lineCap = [_capStyleConverter toLineCap:_strokeData.strokeCapStyle];
    layer.lineJoin = [_joinStyleConverter toLineJoin:_strokeData.strokeJoinStyle];
    [layers addObject:layer];

    [self.layer addSublayer:layer];
  }

  _strokeLayers = layers;

  NSLog(@"drawing...");
}

- (void)startAnimation {
  NSLog(@"animating...");

  for (CAShapeLayer *shape in _strokeLayers) {
    [shape removeAllAnimations];
  }

  const double dtPerStroke = 0.3;
  const int numStrokes = (int)_strokeLayers.count;

  CFTimeInterval localLayerTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];

  for (int i = 0; i < numStrokes; ++i) {
    CAShapeLayer *shape = _strokeLayers[i];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@(kStrokeEndKey)];
    anim.fillMode = kCAFillModeBackwards;
    anim.fromValue = @0;
    anim.toValue = @1.0;
    anim.duration = dtPerStroke;// * (i + 1);
    anim.beginTime = [shape convertTime:(dtPerStroke * i) + localLayerTime fromLayer:self.layer];
    anim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];

    shape.strokeStart = 0;
    shape.strokeEnd = 1.0;

    [shape addAnimation:anim forKey:@(kAnimationName)];
  }
}

@end
