//
//  EWCStrokeData.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EWCStroke;

@interface EWCStrokeData : NSObject

@property double viewLeft;
@property double viewTop;
@property double viewRight;
@property double viewBottom;

@property (readonly) NSArray<EWCStroke *> *strokes;

@end

NS_ASSUME_NONNULL_END
