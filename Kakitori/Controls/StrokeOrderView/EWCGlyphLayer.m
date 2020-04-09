//
//  EWCGlyphLayerDelegate.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/8/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCGlyphLayer.h"

#import <CoreText/CoreText.h>

static const double kEWCMarginScaleFactor = 0.2;

@implementation EWCGlyphLayer

- (UIFont *)findPreferedFont {

  UIFont *font = [UIFont systemFontOfSize:_fontSize];

  if (_preferSerifs) {
    UIFontDescriptor *preferedDescriptor = [[font fontDescriptor]
      fontDescriptorWithDesign:UIFontDescriptorSystemDesignSerif];
    if (preferedDescriptor) {
      UIFont *preferedFont = [UIFont fontWithDescriptor:preferedDescriptor
        size:_fontSize];
      if (preferedFont) { font = preferedFont; }
    }
  }

  return font;
}

- (void)drawInContext:(CGContextRef)ctx {

  UIFont *font = [self findPreferedFont];

  NSDictionary<NSString *, id> *attr = @{
    NSFontAttributeName: font, // font
  };
  NSAttributedString *attrStr = [[NSAttributedString alloc]
    initWithString:_glyph attributes:attr];

  CTLineRef line = CTLineCreateWithAttributedString(
    (CFAttributedStringRef)attrStr);
  CGFloat ascent, descent, leading;
  double lineWidth = CTLineGetTypographicBounds(
    line, &ascent, &descent, &leading);

  double centerX = fabs((self.bounds.size.width - lineWidth) / 2.0);

  // Set text position and draw the line into the graphics context
  CGContextSetTextPosition(ctx, centerX, kEWCMarginScaleFactor * _fontSize);
  CTLineDraw(line, ctx);
  CFRelease(line);
}

@end
