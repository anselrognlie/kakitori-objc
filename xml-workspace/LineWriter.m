//
//  LineWriter.m
//  xml-lib
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "LineWriter.h"

@implementation LineWriter

- (void)write:(NSString *)msg {
  printf("%s", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)writeLine:(NSString *)msg {
  printf("%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
