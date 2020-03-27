//
//  LineWriter.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EWCStatusWriterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWCStdoutStatusWriter : NSObject<EWCStatusWriterProtocol>
@end

NS_ASSUME_NONNULL_END
