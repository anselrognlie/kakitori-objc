//
//  EWCStrokeJoinStyleConverter.h
//  Kakitori
//
//  Created by Ansel Rognlie on 4/5/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EWCStrokeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeJoinStyleConverter : NSObject

- (CGLineJoin)toLineJoin:(EWCStrokeJoinStyle)joinStyle;

@end

NS_ASSUME_NONNULL_END
