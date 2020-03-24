//
//  EWCMoveStrokePart.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCMoveStrokePart.h"

@implementation EWCMoveStrokePart

- (instancetype)initWithX:(double)x y:(double)y isRelative:(BOOL)relative {
  self = [super init];
  if (self) {
    _x = x;
    _y = y;
    _relative = relative;
  }
  return self;
}

@end
