//
//  main.m
//  xml-workspace
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApplicationEntry.h"
#import "StdoutStatusWriter.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSMutableArray *args = [NSMutableArray array];
    for (int i = 0; i < argc; ++i) {
      [args addObject:[NSString stringWithUTF8String:argv[i]]];
    }

    ApplicationEntry *lib = [ApplicationEntry new];
    lib.writer = [StdoutStatusWriter new];

    int err = [lib startWithArgs:args];

    if (err) {
      printf("exit code: %d\n", err);
    }
  }
  
  return 0;
}
