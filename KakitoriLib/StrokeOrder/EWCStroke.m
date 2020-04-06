//
//  EWCStroke.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStroke.h"
#import "EWCStrokePart.h"

@implementation EWCStroke {
  NSMutableArray<EWCStrokePart *> *_parts;
}

- (instancetype)initWithParts:(NSArray<EWCStrokePart *> *)parts {
  self = [super init];
  if (self) {
    _parts = [NSMutableArray<EWCStrokePart *> new];
    for (EWCStrokePart *part in parts) {
      [_parts addObject:part];
    }
  }
  return self;
}

- (NSArray<EWCStrokePart *> *) parts {
  return _parts;
}

@end
