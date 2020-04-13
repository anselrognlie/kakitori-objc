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
    EWCStrokeOrderViewDisplayModeDrawn,
    EWCStrokeOrderViewDisplayModeAnimate,
    EWCStrokeOrderViewDisplayModeDrawnWithLabels,
    EWCStrokeOrderViewDisplayModeAnimateWithLabels,
};

extern const NSInteger EWCStrokeOrderViewDisplayModeCount;

IB_DESIGNABLE
@interface EWCStrokeOrderView : UIView

@property (nonatomic) EWCStrokeData *strokeData;
@property (nonatomic) NSString *glyph;
@property (nonatomic) EWCStrokeOrderViewDisplayMode displayMode;
@property (nonatomic) BOOL preferSerifs;

@end

NS_ASSUME_NONNULL_END
