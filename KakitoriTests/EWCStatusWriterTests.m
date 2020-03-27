//
//  EWCStatusWriterTests.m
//  KakitoriTests
//
//  Created by Ansel Rognlie on 3/27/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWCStdoutStatusWriter.h"
#import "EWCConsoleLogStatusWriter.h"

@interface EWCStatusWriterTests : XCTestCase

@end

@implementation EWCStatusWriterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWriterCodeCoverage {

  NSMutableArray<NSObject<EWCStatusWriterProtocol> *> *writers =
    [NSMutableArray<NSObject<EWCStatusWriterProtocol> *> new];
  [writers addObject:[EWCStdoutStatusWriter new]];
  [writers addObject:[EWCConsoleLogStatusWriter new]];

  for (NSObject<EWCStatusWriterProtocol> *writer in writers) {
    [writer write:@"no newline"];
    [writer writeLine:@"newline"];
  }
}

@end
