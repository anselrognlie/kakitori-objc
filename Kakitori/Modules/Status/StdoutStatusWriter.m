//
//  LineWriter.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "StdoutStatusWriter.h"

@implementation StdoutStatusWriter

- (void)write:(NSString *)msg {
  printf("%s", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)writeLine:(NSString *)msg {
  printf("%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
