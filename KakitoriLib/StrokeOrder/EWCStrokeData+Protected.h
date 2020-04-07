//
//  EWCStrokeData+EWCStrokeData_Protected_m.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeData (Protected)

- (void)setViewportWithLeft:(double)left
    top:(double)top
    right:(double)right
    bottom:(double)bottom;

- (void)addStroke:(EWCStroke *)stroke;

- (void)addStrokeNumber:(EWCStrokeNumber *)number;

- (void)setStrokeWidth:(double)width;

- (void)setFontSize:(double)fontSize;

- (void)setStrokeCapStyle:(EWCStrokeCapStyle)style;

- (void)setStrokeJoinStyle:(EWCStrokeJoinStyle)style;

@end

NS_ASSUME_NONNULL_END
