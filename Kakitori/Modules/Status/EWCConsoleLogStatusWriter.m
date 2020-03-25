//
//  EWCConsoleLogStatusWriter.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/24/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCConsoleLogStatusWriter.h"

@implementation EWCConsoleLogStatusWriter {
  NSString *_pending;
}

- (void)appendMessage:(NSString *)msg {
  _pending = (_pending) ? [_pending stringByAppendingString:msg] : _pending;
}

- (void)write:(NSString *)msg {
  [self appendMessage:msg];
}

- (void)writeLine:(NSString *)msg {
  [self appendMessage:msg];
  NSLog(@"%@", _pending);
  _pending = nil;
}

@end
