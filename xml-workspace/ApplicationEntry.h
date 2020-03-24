//
//  xml_lib.h
//  xml-lib
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusWriterProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationEntry : NSObject

@property NSObject<StatusWriterProtocol> *writer;

- (int)startWithArgs:(NSArray<NSString *>*)args;

@end

NS_ASSUME_NONNULL_END
