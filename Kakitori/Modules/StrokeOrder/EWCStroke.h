//
//  EWCStroke.h
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EWCStrokePart;

NS_ASSUME_NONNULL_BEGIN

@interface EWCStroke : NSObject
- (instancetype)initWithParts:(NSArray<EWCStrokePart *> *)parts;
@end

NS_ASSUME_NONNULL_END
