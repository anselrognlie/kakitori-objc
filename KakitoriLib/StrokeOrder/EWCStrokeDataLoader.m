//
//  EWCStrokeDataLoader.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/26/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeDataLoader.h"
#import "EWCStrokeDataParserDelegate.h"

@implementation EWCStrokeDataLoader {
  EWCStrokeDataParserDelegate *_delegate;
}

- (instancetype)initWithDelegate:(EWCStrokeDataParserDelegate *)delegate {
  self = [super init];
  if (self) {
    _delegate = delegate;
  }
  return self;
}

- (EWCStrokeData *)loadFromString:(NSString *)string error:(NSError **)error {
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
  parser.delegate = _delegate;
  [parser parse];

  if (error) {
    *error = _delegate.lastError;
  }

  return _delegate.strokeData;
}

@end
