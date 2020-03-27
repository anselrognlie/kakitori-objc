//
//  EWCStrokeDataLoader.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/26/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EWCStrokeData;
@class EWCStrokeDataParserDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeDataLoader : NSObject

- (instancetype)initWithDelegate:(EWCStrokeDataParserDelegate *)delegate;
- (EWCStrokeData *)loadFromString:(NSString *)string error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
