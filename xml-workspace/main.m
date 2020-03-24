//
//  main.m
//  xml-workspace
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../xml-lib/xml_lib.h"
#import "../xml-lib/LineWriter.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    NSMutableArray *args = [NSMutableArray array];
    for (int i = 0; i < argc; ++i) {
      [args addObject:[NSString stringWithUTF8String:argv[i]]];
    }

    xml_lib *lib = [xml_lib new];
    lib.writer = [LineWriter new];

    int err = [lib startWithArgs:args];

    if (err) {
      printf("exit code: %d\n", err);
    }
  }
  
  return 0;
}
