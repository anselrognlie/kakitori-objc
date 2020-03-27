//
//  main.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
  NSString * appDelegateClassName;
  @autoreleasepool {
      Class appDelegateClass = NSClassFromString(@"TestingAppDelegate");
      if (!appDelegateClass)
          appDelegateClass = [AppDelegate class];
      appDelegateClassName = NSStringFromClass(appDelegateClass);
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
