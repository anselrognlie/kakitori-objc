//
//  EWCStrokeDataError.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeDataError.h"

static const char kEWCStrokeDataErrorDomain[] = "com.ebbyware.strokedata.ErrorDomain";

const int kEWCViewportParseErrorCode = -101;
char const * const kEWCViewportParseErrorDescription = "unable to parse stroke viewport";

const int kEWCUnknownCommandParseErrorCode = -102;
char const * const kEWCUnknownCommandParseErrorDescription = "unknown command: %c";

const int kEWCMoveParseErrorCode = -103;
char const * const kEWCMoveParseErrorDescription = "unable to parse move stroke part";

const int kEWCCurveParseErrorCode = -104;
char const * const kEWCCurveParseErrorDescription = "unable to parse curve stroke part";

@implementation EWCStrokeDataError

+ (NSError *)errorParsingViewport {
  return [NSError
    errorWithDomain:@(kEWCStrokeDataErrorDomain)
    code:kEWCViewportParseErrorCode
    userInfo:@{
      NSLocalizedDescriptionKey: @(kEWCViewportParseErrorDescription)
    }];
}

+ (NSError *)errorForUnknownCommand:(char)cmd {
  return [NSError
    errorWithDomain:@(kEWCStrokeDataErrorDomain)
    code:kEWCUnknownCommandParseErrorCode
    userInfo:@{
      NSLocalizedDescriptionKey: [NSString
        stringWithFormat:@(kEWCUnknownCommandParseErrorDescription),
        cmd]
    }];
}

+ (NSError *)errorParsingMove {
  return [NSError
    errorWithDomain:@(kEWCStrokeDataErrorDomain)
    code:kEWCMoveParseErrorCode
    userInfo:@{
      NSLocalizedDescriptionKey: @(kEWCMoveParseErrorDescription)
    }];
}

+ (NSError *)errorParsingCurve {
  return [NSError
    errorWithDomain:@(kEWCStrokeDataErrorDomain)
    code:kEWCCurveParseErrorCode
    userInfo:@{
      NSLocalizedDescriptionKey: @(kEWCCurveParseErrorDescription)
    }];
}

@end
