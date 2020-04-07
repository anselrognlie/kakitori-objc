//
//  ViewController.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "ViewController.h"
#import "EWCStrokeOrderView.h"
#import "EWCStrokeDataParserDelegate.h"
#import "EWCStrokeDataLoader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet EWCStrokeOrderView *strokeOrderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@end

@implementation ViewController

- (IBAction)handleTap:(id)sender {
  NSLog(@"%@", @"tapped");
  [self.strokeOrderView startAnimation];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadResources];
}

- (void)loadResources {
  NSBundle *bundle = [NSBundle mainBundle];
  if (bundle) {
    [self loadFromBundle:bundle];
  }
}

- (void)loadFromBundle:(NSBundle *)bundle {
//  NSString *pathToSvg = [bundle pathForResource:@"KVG-4eee" ofType:@"svg"];
//  NSLog(@"%@", pathToSvg);
//  NSURL *urlToSvg = [bundle URLForResource:@"KVG-4eee" withExtension:@"svg"];
  NSURL *urlToSvg = [bundle URLForResource:@"KVG-09b31" withExtension:@"svg"];
  NSLog(@"%@", urlToSvg);

  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  EWCStrokeData *strokeData = [loader loadFromURL:urlToSvg error:&error];

  self.strokeOrderView.strokeData = strokeData;
}

- (void)viewWillLayoutSubviews {
  CGRect viewFrame = self.view.frame;
  if (viewFrame.size.width >= viewFrame.size.height) {
    // wider
    self.rightMargin.active = NO;
    self.bottomMargin.active = YES;
  } else {
    // taller
    self.bottomMargin.active = NO;
    self.leftMargin.active = YES;
  }
}

@end
