//
//  EWCStrokeData.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EWCStroke;
@protocol EWCStrokeDataBuilder;

@interface EWCStrokeData : NSObject

@property (readonly, nonatomic) double viewLeft;
@property (readonly, nonatomic) double viewTop;
@property (readonly, nonatomic) double viewRight;
@property (readonly, nonatomic) double viewBottom;

@property (readonly) NSArray<EWCStroke *> *strokes;

@end

NS_ASSUME_NONNULL_END
