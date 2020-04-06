//
//  EWCStrokeDataToPointConvertor.m
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/3/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeDataToBezierConvertor.h"

#import "EWCStrokeData.h"
#import "EWCStroke.h"
#import "EWCStrokePart.h"
#import "EWCMoveStrokePart.h"
#import "EWCCurveStrokePart.h"

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


@implementation EWCStrokeDataToBezierConvertor{
  NSMutableArray<UIBezierPath *> *_paths;
  CGPoint _currPoint;
  UIBezierPath *_currPath;
}

- (NSArray<UIBezierPath *> *)convertStrokes:(NSArray<EWCStroke *> *)strokes {
  _paths = [NSMutableArray<UIBezierPath *> new];
  _currPoint = CGPointZero;
  _currPath = nil;

  for (EWCStroke *stroke in strokes) {
    for (EWCStrokePart *part in stroke.parts) {
      if ([part isKindOfClass:EWCMoveStrokePart.class]) {
        [self convertMovePart:(EWCMoveStrokePart *)part];
      } else if ([part isKindOfClass:EWCCurveStrokePart.class]) {
        [self convertCurvePart:(EWCCurveStrokePart *)part];
      }
    }
  }

  return _paths;
}

- (void)convertMovePart:(EWCMoveStrokePart *)part {
  CGFloat dx = 0, dy = 0;

  if (part.relative) {
    dx = _currPoint.x;
    dy = _currPoint.y;
  }

  CGPoint newPoint = CGPointMake(part.x + dx, part.y + dy);
  UIBezierPath *newPath = [UIBezierPath bezierPath];
  [newPath moveToPoint:newPoint];

  [_paths addObject:newPath];

  _currPoint = newPoint;
  _currPath = newPath;
}

- (void)convertCurvePart:(EWCCurveStrokePart *)part {
  CGFloat dx = 0, dy = 0;

  if (part.relative) {
    dx = _currPoint.x;
    dy = _currPoint.y;
  }

  CGPoint cp1 = CGPointMake(part.xcp1 + dx, part.ycp1 + dy);
  CGPoint cp2 = CGPointMake(part.xcp2 + dx, part.ycp2 + dy);
  CGPoint p2 = CGPointMake(part.x2 + dx, part.y2 + dy);

  [_currPath addCurveToPoint:p2 controlPoint1:cp1 controlPoint2:cp2];

  _currPoint = p2;
}

@end
