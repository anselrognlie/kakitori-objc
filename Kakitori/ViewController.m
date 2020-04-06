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
@end

@implementation ViewController

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
  NSURL *urlToSvg = [bundle URLForResource:@"KVG-4eee" withExtension:@"svg"];
  NSLog(@"%@", urlToSvg);

  EWCStrokeDataParserDelegate *parserDelegate = [EWCStrokeDataParserDelegate new];
  EWCStrokeDataLoader *loader = [[EWCStrokeDataLoader alloc] initWithDelegate:parserDelegate];
  NSError *error = nil;
  EWCStrokeData *strokeData = [loader loadFromURL:urlToSvg error:&error];

  self.strokeOrderView.strokeData = strokeData;
}


@end
