//
//  EWCMoveStrokePart.h
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EWCStrokePart.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWCMoveStrokePart : EWCStrokePart

@property (readonly, getter=isRelative) BOOL relative;
@property (readonly) double x;
@property (readonly) double y;

- (instancetype)initWithX:(double)x y:(double)y isRelative:(BOOL)relative;

@end

NS_ASSUME_NONNULL_END
