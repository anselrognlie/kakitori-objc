
//
//  EWCCurveStrokePart.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCCurveStrokePart.h"

@implementation EWCCurveStrokePart

- (instancetype)initWithXcp1:(double)xcp1 ycp1:(double)ycp1
  xcp2:(double)xcp2 ycp2:(double)ycp2
  x2:(double)x2 y2:(double)y2
  isRelative:(BOOL)relative {

  self = [super init];
  if (self) {
    _xcp1 = xcp1;
    _ycp1 = ycp1;
    _xcp2 = xcp2;
    _ycp2 = ycp2;
    _x2 = x2;
    _y2 = y2;
    _relative = relative;
  }

  return self;
}

@end
