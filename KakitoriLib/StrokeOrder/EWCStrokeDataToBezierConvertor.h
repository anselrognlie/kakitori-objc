//
//  EWCStrokeDataToPointConvertor.h
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/3/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EWCStroke;
@class UIBezierPath;

@interface EWCStrokeDataToBezierConvertor : NSObject
- (NSArray<UIBezierPath *> *)convertStrokes:(NSArray<EWCStroke *> *)strokes;
@end

NS_ASSUME_NONNULL_END
