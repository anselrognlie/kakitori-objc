//
//  EWCStrokeDataParserDelegate.m
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import "EWCStrokeDataParserDelegate.h"
#import "EWCStatusWriterProtocol.h"
#import "EWCStrokeData.h"
#import "EWCStrokeData+Protected.h"
#import "EWCStrokeDataError.h"
#import "EWCStrokePartTokenizer.h"
#import "EWCMoveStrokePart.h"
#import "EWCCurveStrokePart.h"
#import "EWCStroke.h"
#import "EWCStrokeNumber.h"

static NSString * const kEWCSvgTag = @"svg";
static NSString * const kEWCViewBoxAttr = @"viewBox";
static NSString * const kEWCViewportDelimeter = @" ";
static NSString * const kEWCPathTag = @"path";
static NSString * const kEWCPathDataAttr = @"d";
static NSString * const kEWCGroupTag = @"g";
static NSString * const kEWCIdAttr = @"id";
static NSString * const kEWCStyleAttr = @"style";
static NSString * const kEWCTextTag = @"text";
static NSString * const kEWCTransformAttr = @"transform";
static NSString * const kEWCMatrixOp = @"matrix(";

static NSString * const kEWCStyleStrokeWidthAttr = @"stroke-width";
static NSString * const kEWCStyleStrokeLineCapAttr = @"stroke-linecap";
static NSString * const kEWCStyleStrokeLineJoinAttr = @"stroke-linejoin";

static NSString * const kEWCStyleFontSizeAttr = @"font-size";

static NSString * const kEWCStyleStrokeLineJoinRoundStyle = @"round";
static NSString * const kEWCStyleStrokeLineCapRoundStyle = @"round";

static NSString * const kEWCKvgPathsId = @"kvg:StrokePaths_";
static NSString * const kEWCKvgNumbersId = @"kvg:StrokeNumbers_";

static NSDictionary<NSString *, NSString *> *parseAttributes(NSString *attr);

@implementation EWCStrokeDataParserDelegate {
  NSMutableString *_textChars;
  double _a, _b, _c, _d, _e, _f;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self reset];
  }
  return self;
}

- (void)reset {
  _strokeData = [EWCStrokeData new];
  _lastError = nil;
}

- (void)parser:(NSXMLParser *)parser
  didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
  qualifiedName:(nullable NSString *)qName
  attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

  BOOL success = YES;

  [_writer write:@"Parsed element: "];
  [_writer writeLine:elementName];
  success = [self parseStartStateWithElement:elementName attributes:attributeDict];

  if (! success) {
    [parser abortParsing];
  }
}

- (void)parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
  qualifiedName:(nullable NSString *)qName {

  BOOL success = YES;

  success = [self parseEndStateWithElement:elementName];

  if (! success) {
    [parser abortParsing];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  [_textChars appendString:string];
}

- (BOOL)parseEndStateWithElement:(NSString *)elementName {

  if ([kEWCTextTag isEqualToString:elementName]) {
    EWCStrokeNumber *number = [EWCStrokeNumber
      strokeNumberWithText:_textChars
      transform:_a :_b :_c :_d :_e :_f];

    _textChars = nil;

    [_strokeData addStrokeNumber:number];
  }

  return YES;
}

- (BOOL)parseStartStateWithElement:(NSString *)elementName
  attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

  if ([kEWCSvgTag isEqualToString:elementName]) {
    return [self parseViewport:attributeDict[kEWCViewBoxAttr]];
  } else if ([kEWCPathTag isEqualToString:elementName]) {
    return [self parsePath:attributeDict[kEWCPathDataAttr]];
  } else if ([kEWCGroupTag isEqualToString:elementName]) {
    return [self parseGroup:attributeDict];
  } else if ([kEWCTextTag isEqualToString:elementName]) {
    return [self parseText:attributeDict];
  }

  return YES;
}

- (BOOL)parseGroup:(NSDictionary<NSString *, NSString *> *)attributeDict {
  NSString *idStr = attributeDict[kEWCIdAttr];
  if (idStr == nil) { return YES; }

  if ([idStr hasPrefix:kEWCKvgPathsId]) {
    return [self parsePathsGroupAttributes:attributeDict];
  } else if ([idStr hasPrefix:kEWCKvgNumbersId]) {
    return [self parseNumbersGroupAttributes:attributeDict];
  }

  return YES;
}

- (BOOL)parseText:(NSDictionary<NSString *, NSString *> *)attributeDict {
  NSString *transform = attributeDict[kEWCTransformAttr];
  if (transform) {
    if ([transform hasPrefix:kEWCMatrixOp]) {
      NSString *numbers = [transform substringFromIndex:kEWCMatrixOp.length];
      NSScanner *scanner = [NSScanner scannerWithString:numbers];
      double *t[] = { &_a, &_b, &_c, &_d, &_e, &_f };
      for (int i = 0; i < sizeof(t) / sizeof(*t); ++i) {
        BOOL parsed = [scanner scanDouble:t[i]];
        if (! parsed) {
          return NO;
        }
      }

      _textChars = [NSMutableString new];
    } else {
      return NO;
    }
  } else {
    return NO;
  }

  return YES;
}

- (BOOL)parsePathsGroupAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
  NSString *style = attributes[kEWCStyleAttr];
  if (style == nil) { return NO; }

  NSDictionary<NSString *, NSString *> *styleAttr = parseAttributes(style);
  return [self parsePathsStyleAttributes:styleAttr];
}

- (BOOL)parseNumbersGroupAttributes:(NSDictionary<NSString *, NSString *> *)attributes {
  NSString *style = attributes[kEWCStyleAttr];
  if (style == nil) { return NO; }

  NSDictionary<NSString *, NSString *> *styleAttr = parseAttributes(style);
  return [self parseNumbersStyleAttributes:styleAttr];
}


- (BOOL)parsePathsStyleAttributes:(NSDictionary<NSString *, NSString *> *)styleAttr {

  NSString *strokeWidthStr = styleAttr[kEWCStyleStrokeWidthAttr];
  if (strokeWidthStr) {
    NSScanner *scanner = [NSScanner scannerWithString:strokeWidthStr];
    double result;
    BOOL parsed = [scanner scanDouble:&result];
    if (! parsed) { return NO; }

    [_strokeData setStrokeWidth:result];
  }

  NSString *strokeCapStyle = styleAttr[kEWCStyleStrokeLineCapAttr];
  if (strokeCapStyle) {
    if ([strokeCapStyle isEqualToString:kEWCStyleStrokeLineCapRoundStyle]) {
      [_strokeData setStrokeCapStyle:EWCStrokeCapRound];
    } else {
      return NO;
    }
  }

  NSString *strokeJoinStyle = styleAttr[kEWCStyleStrokeLineJoinAttr];
  if (strokeJoinStyle) {
    if ([strokeJoinStyle isEqualToString:kEWCStyleStrokeLineJoinRoundStyle]) {
      [_strokeData setStrokeJoinStyle:EWCStrokeJoinRound];
    } else {
      return NO;
    }
  }

  return YES;
}

- (BOOL)parseNumbersStyleAttributes:(NSDictionary<NSString *, NSString *> *)styleAttr {

  NSString *fontSizeStr = styleAttr[kEWCStyleFontSizeAttr];
  if (fontSizeStr) {
    NSScanner *scanner = [NSScanner scannerWithString:fontSizeStr];
    double result;
    BOOL parsed = [scanner scanDouble:&result];
    if (! parsed) { return NO; }

    [_strokeData setFontSize:result];
  }

  return YES;
}

- (BOOL)parseViewport:(NSString *)viewportString {

  NSArray<NSString *> *parts = [viewportString
    componentsSeparatedByString:kEWCViewportDelimeter];

  if (parts.count != 4) {
    _lastError = [EWCStrokeDataError errorParsingViewport];
    return NO;
  }

  [_strokeData
    setViewportWithLeft:parts[0].doubleValue
    top:parts[1].doubleValue
    right:parts[2].doubleValue
    bottom:parts[3].doubleValue];

  [_writer writeLine:[NSString stringWithFormat:@"[viewBox %g, %g, %g, %g]",
    _strokeData.viewLeft,
    _strokeData.viewTop,
    _strokeData.viewRight,
    _strokeData.viewBottom]];

  return YES;
}

- (BOOL)parsePath:(NSString *)dataAttr {
  EWCStrokePartTokenizer *tokens = [EWCStrokePartTokenizer parserForString:dataAttr];
  NSMutableArray<EWCStrokePart *> *parts = [NSMutableArray<EWCStrokePart *> new];
  BOOL success = YES;
  char cmd;

  while ((cmd = [tokens nextCommand]) != 0) {
    BOOL isRelative = NO;
    EWCStrokePart *part = nil;
    success = NO;

    switch (cmd) {
      case 'm':
        isRelative = YES;
        // fallthrough
      case 'M':
        part = [self parseMoveToUsingTokenizer:tokens relative:isRelative];
      break;

      case 'c':
        isRelative = YES;
        // fallthrough
      case 'C':
        part = [self parseCurveUsingTokenizer:tokens relative:isRelative];
      break;

      default:
        _lastError = [EWCStrokeDataError errorForUnknownCommand:cmd];
        return NO;
    }

    if (! part) break;
    [parts addObject:part];
    success = YES;
  }

  if (success && parts.count > 0) {
    [self setStrokeWithParts:parts];
  }

  return success;
}

- (EWCStrokePart *)parseMoveToUsingTokenizer:(EWCStrokePartTokenizer *)tokenizer
  relative:(BOOL)isRelative {

  double x = [tokenizer nextNumber];
  double y = [tokenizer nextNumber];

  if (isnan(x) || isnan(y)) {
    _lastError = [EWCStrokeDataError errorParsingMove];
    return nil;
  }

  [_writer writeLine:[NSString stringWithFormat:@"[%c %g, %g]",
    isRelative ? 'm' : 'M',
    x,
    y]];

  return [[EWCMoveStrokePart alloc] initWithX:x y:y isRelative:isRelative];
}

- (EWCStrokePart *)parseCurveUsingTokenizer:(EWCStrokePartTokenizer *)tokenizer
  relative:(BOOL)isRelative {

  double xcp1 = [tokenizer nextNumber];
  double ycp1 = [tokenizer nextNumber];
  double xcp2 = [tokenizer nextNumber];
  double ycp2 = [tokenizer nextNumber];
  double x2 = [tokenizer nextNumber];
  double y2 = [tokenizer nextNumber];

  if (isnan(xcp1) || isnan(ycp1) || isnan(xcp2) || isnan(ycp2) || isnan(x2) || isnan(y2)) {
    _lastError = [EWCStrokeDataError errorParsingCurve];
    return nil;
  }

  [_writer writeLine:[NSString stringWithFormat:@"[%c (%g, %g) (%g, %g) (%g, %g)]",
    isRelative ? 'c' : 'C',
    xcp1, ycp1,
    xcp2, ycp2,
    x2, y2]];

  return [[EWCCurveStrokePart alloc] initWithXcp1:xcp1 ycp1:ycp1
    xcp2:xcp2 ycp2:ycp2
    x2:x2 y2:y2
    isRelative:isRelative];
}

- (void)setStrokeWithParts:(NSArray<EWCStrokePart *> *)parts {
  EWCStroke *stroke = [[EWCStroke alloc] initWithParts:parts];
  [_strokeData addStroke:stroke];
}

@end

static NSDictionary<NSString *, NSString *> *parseAttributes(NSString *attr) {
  NSArray<NSString *> *pairArray = [attr componentsSeparatedByString:@";"];
  NSMutableDictionary<NSString *, NSString *> *result =
    [NSMutableDictionary<NSString *, NSString *> new];

  for (NSString *pairStr in pairArray) {
    if (pairStr.length == 0) { continue; }

    NSArray<NSString *> *pair = [pairStr componentsSeparatedByString:@":"];
    [result setValue:pair[1] forKey:pair[0]];
  }

  return result;
}
