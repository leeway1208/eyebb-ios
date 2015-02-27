//
//  JSONAutoSerializer.h
//  TestOCRuntimeProgramming
//
//  Created by freeZn on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONAutoSerializer : NSObject

+ (JSONAutoSerializer *)sharedSerializer;
- (NSString *)serializeObject:(id)theObject;
@end
