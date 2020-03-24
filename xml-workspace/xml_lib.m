//
//  xml_lib.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "xml_lib.h"
#import "LineWriter.h"
#import "EWCStrokeDataParserDelegate.h"

@implementation xml_lib {
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

//- (int)start {
//  int err = 0;
//  int index = 0;
//  for (NSString *arg in _args) {
//    int printResult = [self printArg:arg atIndex:index];
//    ++index;
//
//    if (! printResult) {
//      err = 1;
//    }
//  }
//
//  return err;
//}
//
//- (int)printArg:(NSString *)arg atIndex:(int)index {
//  [_writer writeLine:[NSString stringWithFormat:@"%d, %@", index, arg]];
//  return 1;
//}

- (int)start {
  int err = 0;

//  [_writer writeLine:[NSString stringWithFormat:@"file: %@", _xmlFilename]];

  NSURL *filePath = [NSURL fileURLWithPath:_xmlFilename];
  NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:filePath];
  _delegate.writer = _writer;
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
