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

@implementation EWCStrokeOrderView {
  EWCStrokeCapStyleConverter *_capStyleConverter;
  EWCStrokeJoinStyleConverter *_joinStyleConverter;
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
  return self;
}

- (void)setStrokeData:(EWCStrokeData *)data {
  _strokeData = data;
  [self setNeedsDisplay];
}

- (void)layoutSubviews {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
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
    [[UIColor blackColor] setStroke];
    path.lineWidth = _strokeData.strokeWidth * sx;
    path.lineCapStyle = [_capStyleConverter toLineCap:_strokeData.strokeCapStyle];
    path.lineJoinStyle = [_joinStyleConverter toLineJoin:_strokeData.strokeJoinStyle];
    [path stroke];
  }

  NSLog(@"drawing...");
}

@end
