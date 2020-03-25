//
//  EWCStrokeDataParserDelegate.h
//  Kakitori
//
//  Created by Ansel Rognlie on 3/23/20.
//  Copyright © 2020 Ansel Rognlie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EWCStatusWriterProtocol;
@class EWCStrokeData;

NS_ASSUME_NONNULL_BEGIN

@interface EWCStrokeDataParserDelegate : NSObject<NSXMLParserDelegate>

@property NSObject<EWCStatusWriterProtocol> *writer;
@property (readonly) NSError *lastError;
@property (readonly) EWCStrokeData *strokeData;

- (void)reset;

- (void)parser:(NSXMLParser *)parser
  didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
  qualifiedName:(nullable NSString *)qName
  attributes:(NSDictionary<NSString *, NSString *> *)attributeDict;

@end

NS_ASSUME_NONNULL_END
