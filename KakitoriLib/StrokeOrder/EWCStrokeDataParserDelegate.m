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

static NSString * const kEWCSvgTag = @"svg";
static NSString * const kEWCViewBoxAttr = @"viewBox";
static NSString * const kEWCViewportDelimeter = @" ";
static NSString * const kEWCPathTag = @"path";
static NSString * const kEWCPathDataAttr = @"d";
static NSString * const kEWCGroupTag = @"g";
static NSString * const kEWCIdAttr = @"id";
static NSString * const kEWCStyleAttr = @"style";

static NSString * const kEWCStyleStrokeWidthAttr = @"stroke-width";
static NSString * const kEWCStyleStrokeLineCapAttr = @"stroke-linecap";
static NSString * const kEWCStyleStrokeLineJoinAttr = @"stroke-linejoin";

static NSString * const kEWCStyleStrokeLineJoinRoundStyle = @"round";
static NSString * const kEWCStyleStrokeLineCapRoundStyle = @"round";

static NSString * const kEWCKvgId = @"kvg:StrokePaths_";
static const int kEWCKvgIdIndexEnd = 16;

static NSDictionary<NSString *, NSString *> *parseAttributes(NSString *attr);

@implementation EWCStrokeDataParserDelegate

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

- (BOOL)parseStartStateWithElement:(NSString *)elementName
  attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

  if ([kEWCSvgTag isEqualToString:elementName]) {
    return [self parseViewport:attributeDict[kEWCViewBoxAttr]];
  } else if ([kEWCPathTag isEqualToString:elementName]) {
    return [self parsePath:attributeDict[kEWCPathDataAttr]];
  } else if ([kEWCGroupTag isEqualToString:elementName]) {
    return [self parseGroup:attributeDict];
  }

  return YES;
}

- (BOOL)parseGroup:(NSDictionary<NSString *, NSString *> *)attributeDict {
  NSString *idStr = attributeDict[kEWCIdAttr];
  if (idStr == nil) { return YES; }

  if (idStr.length < kEWCKvgIdIndexEnd) { return YES; }

  if (! [[idStr substringToIndex:kEWCKvgIdIndexEnd] isEqualToString:kEWCKvgId]) {
    return YES;
  }

  NSString *style = attributeDict[kEWCStyleAttr];
  if (style == nil) { return YES; }

  NSDictionary<NSString *, NSString *> *styleAttr = parseAttributes(style);
  return [self parseStyleAttributes:styleAttr];
}

- (BOOL)parseStyleAttributes:(NSDictionary<NSString *, NSString *> *)styleAttr {

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
