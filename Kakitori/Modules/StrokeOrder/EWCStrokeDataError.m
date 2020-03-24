//
//  EWCStrokeDataError.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeDataError.h"

static const char kEWCStrokeDataErrorDomain[] = "com.ebbyware.strokedata.ErrorDomain";

static const int kEWCViewportParseErrorCode = -101;
static const char kEWCViewportParseErrorDescription[] = "unable to parse stroke viewport";

static const int kEWCUnknownCommandParseErrorCode = -102;
static const char kEWCUnknownCommandParseErrorDescription[] = "unknown command: %c";

static const int kEWCMoveParseErrorCode = -103;
static const char kEWCMoveParseErrorDescription[] = "unable to parse move stroke part";

static const int kEWCCurveParseErrorCode = -104;
static const char kEWCCurveParseErrorDescription[] = "unable to parse curve stroke part";

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
