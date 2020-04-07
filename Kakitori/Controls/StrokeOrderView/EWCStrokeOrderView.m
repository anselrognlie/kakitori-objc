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
#import "EWCStrokeNumber.h"

#import "EWCStrokeCapStyleConverter.h"
#import "EWCStrokeJoinStyleConverter.h"

IB_DESIGNABLE

const NSInteger EWCStrokeOrderViewDisplayModeCount = EWCStrokeOrderViewDisplayModeAnimateWithLabels + 1;

static const char kStrokeEndKey[] = "strokeEnd";
static const char kAnimationName[] = "stroke";

@interface EWCStrokeOrderView ()
@property (nonatomic) BOOL showStrokeCount;
@end

@implementation EWCStrokeOrderView {
  EWCStrokeCapStyleConverter *_capStyleConverter;
  EWCStrokeJoinStyleConverter *_joinStyleConverter;
  BOOL _needsLayout;
  NSArray<CAShapeLayer *> *_strokeLayers;
  NSArray<CATextLayer *> *_labelLayers;
  BOOL _showStrokeCount;
  EWCStrokeOrderViewDisplayMode _displayMode;
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
  _showStrokeCount = YES;
  return self;
}

- (void)setDisplayMode:(EWCStrokeOrderViewDisplayMode)mode {
  _displayMode = mode;
  [self applyDisplayMode];
}

- (void)applyDisplayMode {
  switch (_displayMode) {
    case EWCStrokeOrderViewDisplayModePlain:
      self.showStrokeCount = NO;
      [self stopAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeAnimate:
      self.showStrokeCount = NO;
      [self startAnimation];
    break;

    case EWCStrokeOrderViewDisplayModePlainWithLabels:
      self.showStrokeCount = YES;
      [self stopAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeAnimateWithLabels:
      self.showStrokeCount = YES;
      [self startAnimation];
    break;
  }
}

- (void)setStrokeData:(EWCStrokeData *)data {
  _strokeData = data;
  _needsLayout = YES;

  [self setNeedsLayout];
}

- (void)setShowStrokeCount:(BOOL)show {
  _showStrokeCount = show;
  for (CATextLayer *label in _labelLayers) {
    label.hidden = ! _showStrokeCount;
  }
}

- (void)layoutSubviews {
  if (! _needsLayout) { return; }
  if (! _strokeData) { return; }

  _needsLayout = NO;

  for (CALayer *layer in self.layer.sublayers) {
    [layer removeFromSuperlayer];
  }

  NSMutableArray<CAShapeLayer *> *layers = [NSMutableArray<CAShapeLayer *> new];
  NSMutableArray<CATextLayer *> *labels = [NSMutableArray<CATextLayer *> new];

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

  NSArray<EWCStrokeNumber *> *numbers = _strokeData.numbers;
  double fontSize = _strokeData.fontSize * 0.6 * sx;
  for (EWCStrokeNumber *number in numbers) {
    CGAffineTransform textTransform = CGAffineTransformMake(
      number.a, number.b, number.c, number.d, number.e, number.f);
    CGAffineTransform labelTransform =
      CGAffineTransformConcat(textTransform, t);

    // adjust the transform (remove scale, and adjust offset based on font)
    labelTransform.a = labelTransform.d = 1.0;
    labelTransform.ty -= fontSize;
    labelTransform.tx += (fontSize * 0.3);

    NSDictionary<NSString *, id> *myAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:fontSize], // font
        NSForegroundColorAttributeName: [UIColor grayColor]             // text color
    };
    NSAttributedString *myAttributedString = [[NSAttributedString alloc]
      initWithString:number.text attributes:myAttributes];

    CATextLayer *layer = [CATextLayer new];
    layer.string = myAttributedString;
    layer.frame = self.layer.bounds;
    [layer setAffineTransform:labelTransform];
    layer.hidden = ! _showStrokeCount;
    [labels addObject:layer];

    [self.layer addSublayer:layer];
  }

  _labelLayers = labels;

  NSLog(@"drawing...");
}

- (void)stopAnimation {
  for (CAShapeLayer *shape in _strokeLayers) {
    [shape removeAllAnimations];
  }

  for (CATextLayer *label in _labelLayers) {
    [label removeAllAnimations];
  }
}

- (void)startAnimation {
  NSLog(@"animating...");

  [self stopAnimation];

  const double dtPerStroke = 0.3;
  const int numStrokes = (int)_strokeLayers.count;

  CFTimeInterval localLayerTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];

  for (int i = 0; i < numStrokes; ++i) {
    CAShapeLayer *shape = _strokeLayers[i];
    CATextLayer *label = _labelLayers[i];

    CABasicAnimation *labelAnim = [CABasicAnimation animationWithKeyPath:@"hidden"];
    labelAnim.fillMode = kCAFillModeBackwards;
    labelAnim.fromValue = @(YES);
    labelAnim.toValue = @(! _showStrokeCount);
    labelAnim.duration = 0;
    labelAnim.beginTime = [label convertTime:(dtPerStroke * i) + localLayerTime fromLayer:self.layer];

    label.hidden = ! _showStrokeCount;

    [label addAnimation:labelAnim forKey:@"visible"];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@(kStrokeEndKey)];
    anim.fillMode = kCAFillModeBackwards;
    anim.fromValue = @0;
    anim.toValue = @1.0;
    anim.duration = dtPerStroke;
    anim.beginTime = [shape convertTime:(dtPerStroke * (i + 0.5)) + localLayerTime fromLayer:self.layer];
    anim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];

    shape.strokeStart = 0;
    shape.strokeEnd = 1.0;

    [shape addAnimation:anim forKey:@(kAnimationName)];
  }
}

@end
