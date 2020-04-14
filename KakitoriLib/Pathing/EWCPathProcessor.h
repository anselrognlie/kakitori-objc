//
//  EWCPathProcessor.h
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCPathProcessor : NSObject

- (NSArray<NSValue *> *)douglasPeuckerSimplifyPoints:(NSArray<NSValue *> *)points
  epsilon:(double)epsilon;

@end

NS_ASSUME_NONNULL_END
