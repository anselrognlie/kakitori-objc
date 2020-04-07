//
//  EWCStrokeNumber.h
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/6/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeNumber : NSObject
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) double a;
@property (nonatomic, readonly) double b;
@property (nonatomic, readonly) double c;
@property (nonatomic, readonly) double d;
@property (nonatomic, readonly) double e;
@property (nonatomic, readonly) double f;

- (instancetype)initWithText:(NSString *)text
  transform:(double)a :(double)b :(double)c :(double)d :(double)e :(double)f;

+ (instancetype)strokeNumberWithText:(NSString *)text
  transform:(double)a :(double)b :(double)c :(double)d :(double)e :(double)f;

@end

NS_ASSUME_NONNULL_END
