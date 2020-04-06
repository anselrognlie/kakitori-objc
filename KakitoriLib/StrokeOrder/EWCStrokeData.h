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
@class UIBezierPath;

typedef NS_ENUM(NSInteger, EWCStrokeCapStyle) {
    EWCStrokeCapRound
};

typedef NS_ENUM(NSInteger, EWCStrokeJoinStyle) {
    EWCStrokeJoinRound
};

@interface EWCStrokeData : NSObject

@property (readonly, nonatomic) double viewLeft;
@property (readonly, nonatomic) double viewTop;
@property (readonly, nonatomic) double viewRight;
@property (readonly, nonatomic) double viewBottom;

@property (readonly, nonatomic) double strokeWidth;
@property (readonly, nonatomic) EWCStrokeCapStyle strokeCapStyle;
@property (readonly, nonatomic) EWCStrokeJoinStyle strokeJoinStyle;

@property (readonly) NSArray<EWCStroke *> *strokes;

- (NSArray<UIBezierPath *> *)convertToPoints;

@end

NS_ASSUME_NONNULL_END
