//
//  EWCStrokeOrderView.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeOrderView.h"

IB_DESIGNABLE

@implementation EWCStrokeOrderView {
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    self = [self initInternal];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self = [self initInternal];
  }
  return self;
}

- (instancetype)initInternal {
  return self;
}

- (void)layoutSubviews {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
