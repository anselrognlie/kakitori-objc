//
//  EWCGlyphLayerDelegate.m
//  Kakitori
//
//  Created by Ansel Rognlie on 4/8/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCGlyphLayer.h"

#import <CoreText/CoreText.h>

@implementation EWCGlyphLayer

- (void)drawInContext:(CGContextRef)ctx {

  UIFont *font = [UIFont systemFontOfSize:_fontSize];

  UIFontDescriptor *preferedDescriptor = [[font fontDescriptor]
    fontDescriptorWithDesign:UIFontDescriptorSystemDesignSerif];
  if (preferedDescriptor) {
    UIFont *preferedFont = [UIFont fontWithDescriptor:preferedDescriptor
      size:_fontSize];
    if (preferedFont) { font = preferedFont; }
  }

  NSDictionary<NSString *, id> *attr = @{
    NSFontAttributeName: font, // font
  };
  NSAttributedString *attrStr = [[NSAttributedString alloc]
    initWithString:_glyph attributes:attr];

  CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrStr);
  CGFloat ascent, descent, leading;
  double lineWidth = CTLineGetTypographicBounds(
    line, &ascent, &descent, &leading);

  double xPos = fabs((self.bounds.size.width - lineWidth) / 2.0);
  double yPos = fabs((self.bounds.size.height - (ascent + descent)) / 2.0);

  // Set text position and draw the line into the graphics context
  CGContextSetTextPosition(ctx, xPos, 0.2 * _fontSize);
  CTLineDraw(line, ctx);
  CFRelease(line);
}

@end
