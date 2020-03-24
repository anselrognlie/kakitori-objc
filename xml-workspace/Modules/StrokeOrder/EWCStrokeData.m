//
//  EWCStrokeData.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeData.h"
#import "EWCStrokeData+Protected.h"

@implementation EWCStrokeData {
  NSMutableArray<EWCStroke *> *_strokes;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _viewLeft = 0;
    _viewTop = 0;
    _viewRight = 0;
    _viewBottom = 0;
    _strokes = [NSMutableArray<EWCStroke *> new];
  }
  return self;
}

- (NSArray<EWCStroke *> *)strokes {
  return _strokes;
}

- (void)addStroke:(EWCStroke *)stroke {
  [_strokes addObject:stroke];
}

@end
