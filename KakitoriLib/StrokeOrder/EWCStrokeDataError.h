//
//  EWCStrokeDataError.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern const int kEWCViewportParseErrorCode;
extern char const * const kEWCViewportParseErrorDescription;

extern const int kEWCUnknownCommandParseErrorCode;
extern char const * const kEWCUnknownCommandParseErrorDescription;

extern const int kEWCMoveParseErrorCode;
extern char const * const kEWCMoveParseErrorDescription;

extern const int kEWCCurveParseErrorCode;
extern char const * const kEWCCurveParseErrorDescription;

@interface EWCStrokeDataError : NSError

+ (NSError *)errorParsingViewport;
+ (NSError *)errorForUnknownCommand:(char)cmd;
+ (NSError *)errorParsingMove;
+ (NSError *)errorParsingCurve;

@end

NS_ASSUME_NONNULL_END
