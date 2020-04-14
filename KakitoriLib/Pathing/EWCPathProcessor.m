//
//  EWCPathProcessor.m
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCPathProcessor.h"

#import <UIKit/UIKit.h>

static void findNormalFormCoefficients(
  CGPoint p0, CGPoint p1,
  double  * _Nonnull out_a, double * _Nonnull out_b, double * _Nonnull out_c) {

  const double a = p1.y - p0.y;
  const double b = p0.x - p1.x;
  const double c = (p1.x - p0.x) * p0.y + (p0.y - p1.y) * p0.x;

  *out_a = a;
  *out_b = b;
  *out_c = c;
}

static double denominatorForPerpendicularDistance(
  double a, double b) {

  return sqrt(a * a + b * b);
}

static double perpendicularDistanceWithDenominator(
  double a, double b, double c,
  double denominator,
  double x, double y) {

  return fabs((a * x + b * y + c)) / denominator;
}

@implementation EWCPathProcessor

/**
  Implements Douglas-Peucker path simplification as described at:
  https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
 */
- (NSArray<NSValue *> *)douglasPeuckerSimplifyPoints:(NSArray<NSValue *> *)points
  epsilon:(double)epsilon {

  double distMax = 0;
  int indexMax = 1;
  const int lastIndex = (int)points.count - 1;
  const CGPoint p0 = points[0].CGPointValue;
  const CGPoint p1 = points[lastIndex].CGPointValue;

  double a, b, c;
  findNormalFormCoefficients(p0, p1, &a, &b, &c);
  const double distDenom = denominatorForPerpendicularDistance(a, b);

  for (int i = 1; i < lastIndex; ++i) {
    const CGPoint p = points[i].CGPointValue;
    const double x = p.x, y = p.y;
    const double dist =
      perpendicularDistanceWithDenominator(a, b, c, distDenom, x, y);
    if (dist > distMax) {
      distMax = dist;
      indexMax = i;
    }
  }

  if (distMax > epsilon) {
    NSArray<NSValue *> *leftPoints =
      [points subarrayWithRange:NSMakeRange(0, indexMax + 1)];
    NSArray<NSValue *> *rightPoints =
      [points subarrayWithRange:NSMakeRange(indexMax, points.count - indexMax)];
    NSArray<NSValue *> *leftSimplified =
      [self douglasPeuckerSimplifyPoints:leftPoints epsilon:epsilon];
    NSArray<NSValue *> *rightSimplified =
      [self douglasPeuckerSimplifyPoints:rightPoints epsilon:epsilon];
    return [leftSimplified arrayByAddingObjectsFromArray:
      [rightSimplified subarrayWithRange:NSMakeRange(1, rightSimplified.count - 1)]];
  } else {
    return [NSArray<NSValue *> arrayWithObjects:points[0], points[lastIndex], nil];
  }
}

@end
