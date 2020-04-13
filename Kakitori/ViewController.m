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
@end

@implementation ViewController {
  EWCStrokeOrderViewDisplayMode _displayMode;
}

- (IBAction)handleTap:(id)sender {
//  NSLog(@"%@", @"tapped");

  _displayMode = (_displayMode + 1) % EWCStrokeOrderViewDisplayModeCount;
  self.strokeOrderView.displayMode = _displayMode;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadResources];
  _displayMode = EWCStrokeOrderViewDisplayModePlain;
  self.strokeOrderView.displayMode = _displayMode;
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

//  self.strokeOrderView.preferSerifs = NO;
  self.strokeOrderView.strokeData = strokeData;
//  self.strokeOrderView.glyph = @"\u9f98";
}

- (void)viewDidLayoutSubviews {
  CGRect viewFrame = self.view.frame;
  if (viewFrame.size.width >= viewFrame.size.height) {
    // wider
    [self.rightMargin setActive:NO];
    [self.bottomMargin setActive:YES];
  } else {
    // taller
    [self.bottomMargin setActive:NO];
    [self.rightMargin setActive:YES];
  }
}

- (IBAction)fromSegue:(UIStoryboardSegue*)unwindSegue {}

@end
