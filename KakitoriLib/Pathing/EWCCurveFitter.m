//
//  EWCCurveFitter.m
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCCurveFitter.h"

#import <UIKit/UIKit.h>

static CGPoint subtractPoints(CGPoint p0, CGPoint p1) {
  return CGPointMake(p1.x - p0.x, p1.y - p0.y);
}

static CGPoint addPoints(CGPoint p0, CGPoint p1) {
  return CGPointMake(p1.x + p0.x, p1.y + p0.y);
}

static CGFloat vectorMagnitude(CGPoint v) {
  return sqrt(v.x * v.x + v.y * v.y);
}

static CGPoint scaleVector(CGPoint v, CGFloat s) {
  return CGPointMake(v.x * s, v.y * s);
}

static CGFloat segmentMagnitude(CGPoint p0, CGPoint p1) {
  return vectorMagnitude(subtractPoints(p0, p1));
}

static CGPoint normalizeVector(CGPoint v) {
  CGFloat mag = vectorMagnitude(v);
  return CGPointMake(v.x / mag, v.y / mag);
}

static CGPoint tangentVector(CGPoint p0, CGPoint p1) {
  CGPoint v = subtractPoints(p0, p1);
  return normalizeVector(v);
}

static CGPoint displacePoint(CGPoint p) {
  return addPoints(p, CGPointMake(0.001, 0.001));
}

static CGPoint displacePointIfCoincident(CGPoint p0, CGPoint p1) {
  CGPoint t = tangentVector(p0, p1);
  if (isnan(t.x) || isnan(t.y)) {
    return addPoints(p1, CGPointMake(0.001, 0.001));
  }

  return p1;
}

@implementation EWCCurveFitter{
  double _tangentScale;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _tangentScale = 0.25;
  }
  return self;
}

- (NSArray<NSValue *> *)fitCurveToPoints:(NSArray<NSValue *> *)points {
  NSMutableArray<NSValue *> *curve = [NSMutableArray<NSValue *> new];

  NSArray<NSValue *> *src;
  if (points.count == 1) {
    CGPoint p0 = points[0].CGPointValue;
    CGPoint p1 = displacePoint(p0);
    CGPoint mid = CGPointMake((p0.x + p1.x) / 2.0, (p0.y + p1.y) / 2.0);
    src = [NSArray<NSValue *> arrayWithObjects:
      [NSValue valueWithCGPoint:p0],
      [NSValue valueWithCGPoint:mid],
      [NSValue valueWithCGPoint:p1],
      nil];
  } else if (points.count == 2) {
    CGPoint p0 = points[0].CGPointValue;
    CGPoint p1 = displacePointIfCoincident(p0,points[1].CGPointValue);
    CGPoint mid = CGPointMake((p0.x + p1.x) / 2.0, (p0.y + p1.y) / 2.0);
    src = [NSArray<NSValue *> arrayWithObjects:
      [NSValue valueWithCGPoint:p0],
      [NSValue valueWithCGPoint:mid],
      [NSValue valueWithCGPoint:p1],
      nil];
  } else {
    src = points;
  }

  // first segment
  {
    CGPoint p0 = src[0].CGPointValue,
      p1 = src[1].CGPointValue, p1p1 = src[2].CGPointValue;
    [curve addObject:src[0]];
    [curve addObject:src[0]];
    CGPoint t = tangentVector(p0, p1p1);
    CGFloat segmentLen = segmentMagnitude(p0, p1);
    CGPoint inTan = scaleVector(t, segmentLen * _tangentScale);
    CGPoint inCP = subtractPoints(inTan, p1);
    [curve addObject:[NSValue valueWithCGPoint:inCP]];
    [curve addObject:src[1]];
  }

  // middle segments
  {
    int middleEnd = (int)src.count - 2;
    for (int i = 1; i < middleEnd; ++i) {
      CGPoint p0m1 = src[i - 1].CGPointValue, p0 = src[i].CGPointValue,
        p1 = src[i + 1].CGPointValue, p1p1 = src[i + 2].CGPointValue;

      CGFloat segmentLen = segmentMagnitude(p0, p1) * _tangentScale;
      CGPoint outTan = tangentVector(p0m1, p1);
      outTan = scaleVector(outTan, segmentLen);
      CGPoint outCP = addPoints(outTan, p0);
      CGPoint inTan = tangentVector(p0, p1p1);
      inTan = scaleVector(inTan, segmentLen);
      CGPoint inCP = subtractPoints(inTan, p1);

      [curve addObject:[NSValue valueWithCGPoint:outCP]];
      [curve addObject:[NSValue valueWithCGPoint:inCP]];
      [curve addObject:src[i + 1]];
    }
  }

  // last segment
  {
    int lastIndex = (int)src.count - 1;
    CGPoint p0m1 = src[lastIndex - 2].CGPointValue,
      p0 = src[lastIndex - 1].CGPointValue,
      p1 = src[lastIndex].CGPointValue;
    CGPoint t = tangentVector(p0m1, p1);
    CGFloat segmentLen = segmentMagnitude(p0, p1);
    CGPoint outTan = scaleVector(t, segmentLen * _tangentScale);
    CGPoint outCP = addPoints(outTan, p0);
    [curve addObject:[NSValue valueWithCGPoint:outCP]];
    [curve addObject:src[lastIndex]];
    [curve addObject:src[lastIndex]];
  }

  return curve;
}

@end
