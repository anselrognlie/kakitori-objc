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

#import "EWCGlyphLayer.h"

IB_DESIGNABLE

const NSInteger EWCStrokeOrderViewDisplayModeCount = EWCStrokeOrderViewDisplayModeAnimateWithLabels + 1;

static const char kEWCStrokeEndKey[] = "strokeEnd";
static const char kEWCStrokeAnimationName[] = "stroke";
static const char kEWCHiddenKey[] = "hidden";
static const char kEWCLabelAnimationName[] = "label";
static const double kEWCStrokeStart = 0.0;
static const double kEWCStrokeEnd = 1.0;
static const double kEWCNoScale = 1.0;
static const double kEWCLabelScaleFactor = 0.6;
static const double kEWCLabelXPosFactor = 0.3;
static const double kEWCLabelYPosFactor = 1.0;
static const double kEWCGlyphScaleFactor = 0.9;
static const double kEWCTimeInSecPerStroke = 0.3;
static const BOOL kEWCHiddenStart = YES;
static const double kEWCTimeOffsetFromLabel = 0.5;

@interface EWCStrokeOrderView ()
@property (nonatomic) BOOL showStrokeCount;
@property (nonatomic) BOOL showGlyph;
@end

@implementation EWCStrokeOrderView {
  EWCStrokeCapStyleConverter *_capStyleConverter;
  EWCStrokeJoinStyleConverter *_joinStyleConverter;
  BOOL _needsLayout;
  NSArray<CAShapeLayer *> *_strokeLayers;
  NSArray<CATextLayer *> *_labelLayers;
  CALayer *_glyphLayer;
  BOOL _showStrokeCount;
  EWCStrokeOrderViewDisplayMode _displayMode;
  CGRect _lastFrame;
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
  _capStyleConverter = [EWCStrokeCapStyleConverter new];
  _joinStyleConverter = [EWCStrokeJoinStyleConverter new];
  _needsLayout = YES;
  _showStrokeCount = NO;
  _showGlyph = YES;
  self.displayMode = EWCStrokeOrderViewDisplayModePlain;
}

- (void)setDisplayMode:(EWCStrokeOrderViewDisplayMode)mode {
  _displayMode = mode;
  [self applyDisplayMode];
}

- (void)applyDisplayMode {
  if (! _strokeData) {
    _displayMode = EWCStrokeOrderViewDisplayModePlain;
  }

  switch (_displayMode) {
    case EWCStrokeOrderViewDisplayModePlain:
      self.showGlyph = YES;
      self.showStrokeCount = NO;
      [self stopAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeDrawn:
      self.showGlyph = NO;
      self.showStrokeCount = NO;
      [self stopAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeAnimate:
      self.showGlyph = NO;
      self.showStrokeCount = NO;
      [self startAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeDrawnWithLabels:
      self.showGlyph = NO;
      self.showStrokeCount = YES;
      [self stopAnimation];
    break;

    case EWCStrokeOrderViewDisplayModeAnimateWithLabels:
      self.showGlyph = NO;
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

- (void)setShowGlyph:(BOOL)showGlyph {
  _showGlyph = showGlyph;
  _glyphLayer.hidden = ! _showGlyph;

  for (CAShapeLayer *stroke in _strokeLayers) {
    stroke.hidden = _showGlyph;
  }

  if (_showGlyph) {
    for (CATextLayer *label in _labelLayers) {
      label.hidden = YES;
    }
  }
}

- (void)clearLayers {
  NSArray<CALayer *> *layers = [self.layer.sublayers copy];

  for (CALayer *layer in layers) {
    [layer removeFromSuperlayer];
  }

  _strokeLayers = nil;
  _labelLayers = nil;
  _glyphLayer = nil;
}

- (double)strokeDataScaleX {
  double strokeViewWidth = _strokeData.viewRight - _strokeData.viewLeft;
  return self.bounds.size.width / strokeViewWidth;
}

- (double)strokeDataScaleY {
  double strokeViewHeight = _strokeData.viewBottom - _strokeData.viewTop;
  return self.bounds.size.height / strokeViewHeight;
}

- (CGAffineTransform)strokeDataTransform {

  CGRect bounds = self.bounds;
  CGFloat ox = bounds.origin.x;
  CGFloat oy = bounds.origin.y;
  CGFloat vx = _strokeData.viewLeft;
  CGFloat vy = _strokeData.viewTop;

  CGFloat sx = [self strokeDataScaleX];
  CGFloat sy = [self strokeDataScaleY];

  CGAffineTransform t = CGAffineTransformMakeTranslation(-vx, -vy);
  t = CGAffineTransformScale(t, sx, sy);
  t = CGAffineTransformTranslate(t, ox, oy);

  return t;
}

- (void)createStrokeLayers {
  NSMutableArray<CAShapeLayer *> *layers = [NSMutableArray<CAShapeLayer *> new];

  CGFloat sx = [self strokeDataScaleX];
  CGAffineTransform t = [self strokeDataTransform];

  NSArray<UIBezierPath *> *paths = [_strokeData convertToPoints];
  for (UIBezierPath *path in paths) {
    [path applyTransform:t];

    // create a child layer to hold the path
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.path = path.CGPath;
    layer.strokeStart = kEWCStrokeStart;
    layer.strokeEnd = kEWCStrokeEnd;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = nil;
    layer.lineWidth = _strokeData.strokeWidth * sx;
    layer.lineCap = [_capStyleConverter toLineCap:_strokeData.strokeCapStyle];
    layer.lineJoin = [_joinStyleConverter toLineJoin:_strokeData.strokeJoinStyle];
    layer.hidden = _showGlyph;
    [layers addObject:layer];

    [self.layer addSublayer:layer];
  }

  _strokeLayers = layers;
}

- (void)createLabelLayers {
  NSMutableArray<CATextLayer *> *labels = [NSMutableArray<CATextLayer *> new];

  CGFloat sx = [self strokeDataScaleX];
  CGAffineTransform t = [self strokeDataTransform];

  NSArray<EWCStrokeNumber *> *numbers = _strokeData.numbers;
  double fontSize = _strokeData.fontSize * kEWCLabelScaleFactor * sx;
  for (EWCStrokeNumber *number in numbers) {
    CGAffineTransform textTransform = CGAffineTransformMake(
      number.a, number.b, number.c, number.d, number.e, number.f);
    CGAffineTransform labelTransform =
    CGAffineTransformConcat(textTransform, t);

    // adjust the transform (remove scale, and adjust offset based on font)
    labelTransform.a = labelTransform.d = kEWCNoScale;
    labelTransform.ty -= (fontSize * kEWCLabelYPosFactor);
    labelTransform.tx += (fontSize * kEWCLabelXPosFactor);

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
    layer.hidden = ! _showStrokeCount || _showGlyph;
    [labels addObject:layer];

    [self.layer addSublayer:layer];
  }

  _labelLayers = labels;
}

//- (void)createGlyphLayer {
//  NSString *glyph = _strokeData ? _strokeData.glyph : _glyph;
//
//  double fontSize = self.layer.bounds.size.height * kEWCGlyphScaleFactor;
//  UIFont *font = [UIFont systemFontOfSize:fontSize];
//
//  UIFontDescriptor *preferedDescriptor = [[font fontDescriptor]
//    fontDescriptorWithDesign:UIFontDescriptorSystemDesignSerif];
//  if (preferedDescriptor) {
//    font = [UIFont fontWithDescriptor:preferedDescriptor size:fontSize];
//  }
//
//  NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
////  paragraph.alignment = NSTextAlignmentCenter;
//  paragraph.lineSpacing = 0;
//
//  NSDictionary<NSString *, id> *myAttributes = @{
//    NSFontAttributeName: font, // font
//    NSParagraphStyleAttributeName: paragraph,
//  };
//  NSAttributedString *myAttributedString = [[NSAttributedString alloc]
//    initWithString:glyph attributes:myAttributes];
//
//  CATextLayer *layer = [CATextLayer new];
//  layer.string = myAttributedString;
//  layer.borderColor = [UIColor redColor].CGColor;
//  layer.borderWidth = 2;
//  layer.frame = self.layer.bounds;
//  layer.hidden = ! _showGlyph;
//  layer.alignmentMode = kCAAlignmentCenter;
//  layer.masksToBounds = YES;
//  layer.backgroundColor = [UIColor blueColor].CGColor;
//
//  [self.layer addSublayer:layer];
//
//  _glyphLayer = layer;
//}

- (void)createGlyphLayer {
  NSString *glyph = _strokeData ? _strokeData.glyph : _glyph;

  double fontSize = self.layer.bounds.size.height * kEWCGlyphScaleFactor;

  CGAffineTransform t = CGAffineTransformIdentity;
  t = CGAffineTransformScale(t, 1.0, -1.0);

  EWCGlyphLayer *layer = [EWCGlyphLayer new];
  layer.glyph = glyph;
  layer.fontSize = fontSize;
  layer.frame = self.layer.bounds;
  layer.hidden = ! _showGlyph;
  layer.masksToBounds = YES;
  layer.affineTransform = t;

//  layer.string = myAttributedString;
//  layer.borderColor = [UIColor redColor].CGColor;
//  layer.borderWidth = 2;
//  layer.alignmentMode = kCAAlignmentCenter;
//  layer.backgroundColor = [UIColor blueColor].CGColor;

  [self.layer addSublayer:layer];
  [layer setNeedsDisplay];

  _glyphLayer = layer;
}

- (void)layoutSubviews {
  if (! _strokeData && ! _glyph) { return; }
  if (! _needsLayout && CGRectEqualToRect(self.frame, _lastFrame)) { return; }

  _needsLayout = NO;
  _lastFrame = self.frame;

  [self clearLayers];

  if (_strokeData) {
    if (_strokeData.numbers.count != _strokeData.strokes.count) { return; }

    [self createStrokeLayers];
    [self createLabelLayers];
  }

  [self createGlyphLayer];

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

- (void)configureAnimationForStrokIndex:(int)i localLayerTime:(CFTimeInterval)localLayerTime {
  CAShapeLayer *shape = _strokeLayers[i];

  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@(kEWCStrokeEndKey)];
  anim.fillMode = kCAFillModeBackwards;
  anim.fromValue = @(kEWCStrokeStart);
  anim.toValue = @(kEWCStrokeEnd);
  anim.duration = kEWCTimeInSecPerStroke;
  double startStrokeTime = (kEWCTimeInSecPerStroke * (i + kEWCTimeOffsetFromLabel)) + localLayerTime;
  anim.beginTime = [shape convertTime:startStrokeTime fromLayer:self.layer];
  anim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];

  shape.strokeStart = kEWCStrokeStart;
  shape.strokeEnd = kEWCStrokeEnd;

  [shape addAnimation:anim forKey:@(kEWCStrokeAnimationName)];
}

- (void)configureAnimationForLabelIndex:(int)i localLayerTime:(CFTimeInterval)localLayerTime {
  CATextLayer *label = _labelLayers[i];

  CABasicAnimation *labelAnim = [CABasicAnimation animationWithKeyPath:@(kEWCHiddenKey)];
  labelAnim.fillMode = kCAFillModeBackwards;
  labelAnim.fromValue = @(kEWCHiddenStart);
  labelAnim.toValue = @(! _showStrokeCount);
  double startLabelTime = (kEWCTimeInSecPerStroke * i) + localLayerTime;
  labelAnim.beginTime = [label convertTime:startLabelTime fromLayer:self.layer];

  label.hidden = ! _showStrokeCount;

  [label addAnimation:labelAnim forKey:@(kEWCLabelAnimationName)];
}

- (CFTimeInterval)currentMainLayerTime {
  return [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
}

- (void)startAnimation {
  NSLog(@"animating...");

  [self stopAnimation];

  const int numStrokes = (int)_strokeLayers.count;

  CFTimeInterval localLayerTime = [self currentMainLayerTime];

  for (int i = 0; i < numStrokes; ++i) {
    [self configureAnimationForLabelIndex:i localLayerTime:localLayerTime];
    [self configureAnimationForStrokIndex:i localLayerTime:localLayerTime];
  }
}

@end
