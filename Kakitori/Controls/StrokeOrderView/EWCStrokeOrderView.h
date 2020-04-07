//
//  EWCStrokeOrderView.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/22/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EWCStrokeData;

typedef NS_ENUM(NSInteger, EWCStrokeOrderViewDisplayMode) {
    EWCStrokeOrderViewDisplayModePlain,
    EWCStrokeOrderViewDisplayModeAnimate,
    EWCStrokeOrderViewDisplayModePlainWithLabels,
    EWCStrokeOrderViewDisplayModeAnimateWithLabels,
};

extern const NSInteger EWCStrokeOrderViewDisplayModeCount;

@interface EWCStrokeOrderView : UIControl

//@property NSString *characterData;
@property (nonatomic) EWCStrokeData *strokeData;
@property (nonatomic) EWCStrokeOrderViewDisplayMode displayMode;

@end

NS_ASSUME_NONNULL_END
