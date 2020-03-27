//
//  EWCStrokeDataTests.m
//  KakitoriTests
//
//  Created by Ansel Rognlie on 3/26/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "EWCStrokeData.h"
#import "EWCStrokeDataParserDelegate.h"
#import "EWCStrokeDataLoader.h"
#import "EWCConsoleLogStatusWriter.h"
#import "EWCStrokeDataError.h"

@interface EWCStrokeDataTests : XCTestCase

@end

static NSString * const kKanjiData = @(
#include "TestData/KVG/KVG-4eee.strlit"
);

static NSString * const kKanjiDataViewError = @(
#include "TestData/KVG/KVG-4eee-view-error.strlit"
);

static NSString * const kKanjiDataMoveError = @(
#include "TestData/KVG/KVG-4eee-move-error.strlit"
);

static NSString * const kKanjiDataCurveError = @(
#include "TestData/KVG/KVG-4eee-curve-error.strlit"
);

static NSString * const kKanjiDataCmdError = @(
#include "TestData/KVG/KVG-4eee-cmd-error.strlit"
);

static NSString * const kKanjiDataWithRel = @(
#include "TestData/KVG/KVG-4eee-with-rel.strlit"
);

@implementation EWCStrokeDataTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testBuildingStrokeData {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  EWCStrokeData *strokeData = [loader loadFromString:kKanjiData error:&error];

  XCTAssertEqual(strokeData.strokes.count, 6, "parsed character must have 6 strokes");
}

- (void)testBuildingRelativeStrokeData {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  EWCStrokeData *strokeData = [loader loadFromString:kKanjiDataWithRel error:&error];

  XCTAssertEqual(strokeData.strokes.count, 6, "parsed character must have 6 strokes");
}

- (void)testStrokeDataViewError {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  [loader loadFromString:kKanjiDataViewError error:&error];

  XCTAssertEqual(error.code, kEWCViewportParseErrorCode, "must report viewport error");
}

- (void)testStrokeDataMoveError {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  [loader loadFromString:kKanjiDataMoveError error:&error];

  XCTAssertEqual(error.code, kEWCMoveParseErrorCode, "must report move command error");
}

- (void)testStrokeDataCurveError {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  [loader loadFromString:kKanjiDataCurveError error:&error];

  XCTAssertEqual(error.code, kEWCCurveParseErrorCode, "must report curve command error");
}

- (void)testStrokeDataCmdError {
  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  [loader loadFromString:kKanjiDataCmdError error:&error];

  XCTAssertEqual(error.code, kEWCUnknownCommandParseErrorCode, "must report unknown command error");
}

@end
