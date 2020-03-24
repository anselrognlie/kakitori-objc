//
//  EWCStrokeDataError.h
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeDataError : NSError

+ (NSError *)errorParsingViewport;
+ (NSError *)errorForUnknownCommand:(char)cmd;
+ (NSError *)errorParsingMove;
+ (NSError *)errorParsingCurve;

@end

NS_ASSUME_NONNULL_END
