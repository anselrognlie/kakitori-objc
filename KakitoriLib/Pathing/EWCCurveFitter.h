//
//  EWCCurveFitter.h
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCCurveFitter : NSObject

- (NSArray<NSValue *> *)fitCurveToPoints:(NSArray<NSValue *> *)points;

@end

NS_ASSUME_NONNULL_END
