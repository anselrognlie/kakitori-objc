//
//  EWCStrokeData.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeData.h"
#import "EWCStrokeData+Protected.h"

#import "EWCStrokeDataToBezierConvertor.h"
#import "EWCStrokeNumber.h"

@implementation EWCStrokeData {
  NSMutableArray<EWCStroke *> *_strokes;
  NSMutableArray<EWCStrokeNumber *> *_numbers;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _viewLeft = 0;
    _viewTop = 0;
    _viewRight = 0;
    _viewBottom = 0;
    _strokes = [NSMutableArray<EWCStroke *> new];
    _numbers = [NSMutableArray<EWCStrokeNumber *> new];
  }
  return self;
}

- (NSArray<EWCStroke *> *)strokes {
  return _strokes;
}

- (NSArray<EWCStrokeNumber *> *)numbers {
  return _numbers;
}

- (void)addStroke:(EWCStroke *)stroke {
  [_strokes addObject:stroke];
}

- (void)setViewportWithLeft:(double)left
    top:(double)top
    right:(double)right
    bottom:(double)bottom {

  _viewLeft = left;
  _viewTop = top;
  _viewRight = right;
  _viewBottom = bottom;
}

- (NSArray<UIBezierPath *> *)convertToPoints {
  EWCStrokeDataToBezierConvertor *convertor =
    [EWCStrokeDataToBezierConvertor new];
  return [convertor convertStrokes:_strokes];
}

- (void)setStrokeWidth:(double)width {
  _strokeWidth = width;
}

- (void)setStrokeCapStyle:(EWCStrokeCapStyle)style {
  _strokeCapStyle = style;
}

- (void)setStrokeJoinStyle:(EWCStrokeJoinStyle)style {
  _strokeJoinStyle = style;
}

- (void)setGlyph:(NSString *)glyph {
  _glyph = glyph;
}

- (void)setFontSize:(double)fontSize {
  _fontSize = fontSize;
}

- (void)addStrokeNumber:(EWCStrokeNumber *)number {
  [_numbers addObject:number];
}

@end
