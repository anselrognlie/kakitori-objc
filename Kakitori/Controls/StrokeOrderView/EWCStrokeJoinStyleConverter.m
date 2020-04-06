//
//  EWCStrokeJoinStyleConverter.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/5/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeJoinStyleConverter.h"

@implementation EWCStrokeJoinStyleConverter

- (CGLineJoin)toLineJoin:(EWCStrokeJoinStyle)joinStyle {
  switch (joinStyle) {
    case EWCStrokeJoinRound:
    default:
      return kCGLineJoinRound;
  }
}

@end
