//
//  xml_lib.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "ApplicationEntry.h"
#import "EWCStrokeDataParserDelegate.h"
#import "StatusWriterProtocol.h"

@implementation ApplicationEntry {
  NSArray<NSString *>* _args;
  NSString *_xmlFilename;
  EWCStrokeDataParserDelegate *_delegate;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _delegate = [EWCStrokeDataParserDelegate new];
  }
  return self;
}

- (int)startWithArgs:(NSArray<NSString *>*)args {

  _args = args;

  if (args.count < 2) {
    return 1;
  }

  _xmlFilename = _args[1];
  
  return [self start];
}

- (int)start {
  int err = 0;

  NSURL *filePath = [NSURL fileURLWithPath:_xmlFilename];
  NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:filePath];
  [_delegate reset];
  parser.delegate = _delegate;
  [parser parse];

  NSError *parseErr = _delegate.lastError;
  if (parseErr) {
    err = (int)parseErr.code;
    [_writer writeLine:parseErr.description];
  }

  return err;
}

@end
