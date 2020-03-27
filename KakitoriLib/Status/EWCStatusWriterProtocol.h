//
//  StatusWriterProtocol.h
//  xml-workspace
//
//  Created by Ansel Rognlie on 3/24/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EWCStatusWriterProtocol <NSObject>
- (void)write:(NSString *)msg;
- (void)writeLine:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
