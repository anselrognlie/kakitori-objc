//
//  EWCGlyphLayerDelegate.h
//  Kakitori
//
//  Created by Ansel Rognlie on 4/8/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWCGlyphLayer : CALayer

@property (nonatomic) NSString *glyph;
@property (nonatomic) double fontSize;
@property (nonatomic) BOOL preferSerifs;

- (void)drawInContext:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
