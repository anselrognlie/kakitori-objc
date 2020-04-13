//
//  DrawViewController.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/13/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCDrawViewController.h"
#import "EWCStrokeInputView.h"

@interface EWCDrawViewController ()
@property (weak, nonatomic) IBOutlet EWCStrokeInputView *strokeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@end

@implementation EWCDrawViewController

- (void)viewDidLayoutSubviews {
  CGRect viewFrame = self.view.frame;
  if (viewFrame.size.width >= viewFrame.size.height) {
    // wider
    [self.leftMargin setActive:NO];
    [self.topMargin setActive:YES];
  } else {
    // taller
    [self.topMargin setActive:NO];
    [self.leftMargin setActive:YES];
  }
}

@end
