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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undoLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undoRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undoBottomTallMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undoBottomWideMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearBottomTallMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearCenterTallMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clearCenterWideMargin;

@end

@implementation EWCDrawViewController

- (void)viewDidLayoutSubviews {
  CGRect viewFrame = self.view.frame;
  if (viewFrame.size.width >= viewFrame.size.height) {
    // wider

    self.leftMargin.active = NO;
    self.topMargin.active = YES;

    self.undoLeftMargin.active = NO;
    self.undoBottomTallMargin.active = NO;
    self.undoRightMargin.active = YES;
    self.undoBottomWideMargin.active = YES;

    self.clearBottomTallMargin.active = NO;
    self.clearCenterTallMargin.active = NO;
    self.clearRightMargin.active = YES;
    self.clearCenterWideMargin.active = YES;

  } else {
    // taller

    self.topMargin.active = NO;
    self.leftMargin.active = YES;

    self.undoRightMargin.active = NO;
    self.undoBottomWideMargin.active = NO;
    self.undoLeftMargin.active = YES;
    self.undoBottomTallMargin.active = YES;

    self.clearRightMargin.active = NO;
    self.clearCenterWideMargin.active = NO;
    self.clearBottomTallMargin.active = YES;
    self.clearCenterTallMargin.active = YES;

  }
}

- (IBAction)handleUndo:(id)sender {
  [self.strokeView undo];
}

- (IBAction)handleClear:(id)sender {
  [self.strokeView clear];
}

@end
