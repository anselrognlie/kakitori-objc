//
//  EWCStrokeNumber.m
//  KakitoriLib
//
//  Created by Ansel Rognlie on 4/6/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeNumber.h"

@implementation EWCStrokeNumber

- (instancetype)initWithText:(NSString *)text
  transform:(double)a :(double)b :(double)c :(double)d :(double)e :(double)f {

  self = [super init];
  if (self) {
    _text = text;
    _a = a;
    _b = b;
    _c = c;
    _d = d;
    _e = e;
    _f = f;
  }

  return self;
}

+ (instancetype)strokeNumberWithText:(NSString *)text
  transform:(double)a :(double)b :(double)c :(double)d :(double)e :(double)f {
  EWCStrokeNumber *inst = [EWCStrokeNumber alloc];
  if (inst) {
    inst = [inst initWithText:text transform:a :b :c :d :e :f];
  }

  return inst;
}

@end
