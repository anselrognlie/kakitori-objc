//
//  EWCStrokeCapStyleConverter.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/5/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeCapStyleConverter.h"

@implementation EWCStrokeCapStyleConverter

- (CAShapeLayerLineCap)toLineCap:(EWCStrokeCapStyle)capStyle {
  switch (capStyle) {
    case EWCStrokeCapRound:
    default:
      return kCALineCapRound;
  }
}

@end
