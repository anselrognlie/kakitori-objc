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

typedef NS_ENUM(NSInteger, EWCStrokeParsingState) {
  EWCStrokeParsingStateStart
};

static NSString * const kEWCSvgTag = @"svg";
static NSString * const kEWCViewBoxAttr = @"viewBox";
static NSString * const kEWCViewportDelimeter = @" ";
static NSString * const kEWCPathTag = @"path";
static NSString * const kEWCPathDataAttr = @"d";

@implementation EWCStrokeDataParserDelegate {
  EWCStrokeParsingState _parseState;
}

- (void)reset {
  _strokeData = [EWCStrokeData new];
  _parseState = EWCStrokeParsingStateStart;
  _lastError = nil;
}

- (void)parser:(NSXMLParser *)parser
  didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
  qualifiedName:(nullable NSString *)qName
  attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {

  BOOL success = YES;

//  [_writer writeLine:elementName];
  switch (_parseState) {
    case EWCStrokeParsingStateStart:
      success = [self parseStartStateWithElement:elementName attributes:attributeDict];
    break;
  }

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

  _strokeData.viewLeft = parts[0].doubleValue;
  _strokeData.viewTop = parts[1].doubleValue;
  _strokeData.viewRight = parts[2].doubleValue;
  _strokeData.viewBottom = parts[3].doubleValue;

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
