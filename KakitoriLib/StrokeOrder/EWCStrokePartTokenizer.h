//
//  EWCStrokePartParser.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokePartTokenizer : NSObject

+ (instancetype)parserForString:(NSString *)str;

- (instancetype)initWithString:(NSString *)str;

- (char)nextCommand;
- (double)nextNumber;

@end

NS_ASSUME_NONNULL_END
