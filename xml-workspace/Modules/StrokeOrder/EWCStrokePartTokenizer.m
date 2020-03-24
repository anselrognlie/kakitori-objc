//
//  EWCStrokePartParser.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokePartTokenizer.h"

@implementation EWCStrokePartTokenizer {
  NSString *_sourceStr;
  uint _currentPosition;
}

static short s_numberCharacter(char c) {
  if (c >= '0' && c <= '9') {
    return 1;
  }

  switch (c) {
    case '-':
    case '.':
      return 1;
  }

  return 0;
}

static short s_dividerCharacter(char c) {
  if (c == ' ' || c == ',') {
    return 1;
  }

  return 0;
}

static uint s_nextNotDividerIndex(NSString *str, uint position) {
  unsigned long len = str.length;

  while (position < len) {
    unichar uc = [str characterAtIndex:position];
    char c = (char)(uc & 0xff);
    if (! s_dividerCharacter(c))
    {
      break;
    }
    ++position;
  }

  return position;
}


static uint s_nextNumberCharIndex(NSString *str, uint position) {
  unsigned long len = str.length;

  int afterDivider = s_nextNotDividerIndex(str, position);

  if (afterDivider < len) {
    unichar uc = [str characterAtIndex:afterDivider];
    char c = (char)(uc & 0xff);
    if (s_numberCharacter(c))
    {
      return afterDivider;
    }
  }

  return -1;
}

static uint s_nextNotNumberCharIndex(NSString *str, uint position) {
  unsigned long len = str.length;

  while (position < len) {
    unichar uc = [str characterAtIndex:position];
    char c = (char)(uc & 0xff);
    if (! s_numberCharacter(c))
    {
      break;
    }
    if (c == '-') break;

    ++position;
  }

  return position;
}

+ (instancetype)parserForString:(NSString *)str {
  return [[EWCStrokePartTokenizer alloc] initWithString:str];
}

- (instancetype)initWithString:(NSString *)str {
  self = [super init];
  if (self) {
    _sourceStr = str;
    _currentPosition = 0;
  }
  return self;
}

- (char)nextCommand {
  unsigned long len = _sourceStr.length;

  while (_currentPosition < len) {
    unichar uc = [_sourceStr characterAtIndex:_currentPosition++];
    char c = (char)(uc & 0xff);
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
    {
      return c;
    }
  }

  return 0;
}

- (double)nextNumber {
  uint start = s_nextNumberCharIndex(_sourceStr, _currentPosition);
  if (start == -1) return NAN;

  uint end = s_nextNotNumberCharIndex(_sourceStr, start + 1);
  _currentPosition = end;

  if (start >= end) return NAN;

  NSString *numPart = [_sourceStr substringWithRange:NSMakeRange(start, end - start)];
  return numPart.doubleValue;
}

@end
