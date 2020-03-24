//
//  EWCCurveStrokePart.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWCStrokePart.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWCCurveStrokePart : EWCStrokePart

@property (readonly, getter=isRelative) BOOL relative;
@property (readonly) int xcp1;
@property (readonly) int ycp1;
@property (readonly) int xcp2;
@property (readonly) int ycp2;
@property (readonly) int x2;
@property (readonly) int y2;

- (instancetype)initWithXcp1:(double)xcp1 ycp1:(double)ycp1
  xcp2:(double)xcp2 ycp2:(double)ycp2
  x2:(double)x2 y2:(double)y2
  isRelative:(BOOL)relative;

@end

NS_ASSUME_NONNULL_END
