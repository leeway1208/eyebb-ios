//
//  SerializationComplexEntities.h
//  
//
//  Created by haoero on 10/12.
//  Copyright (c) 2012_haoero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerializationComplexEntities : NSObject


//序列化复杂实体类，传入参数为需要序列化的complexObject与 一个嵌套的实体类类型的数组childSimpleClass，另外childSimpleClassInArray为所有复杂数组中的实体类类型的数组
- (NSString *)serializeObjectWithChildObjectsAndComplexArray:(id)complexObject childSimpleClasses:(NSArray*)childSimpleClasses childSimpleClassInArray:(NSArray*) childSimpleClassInArray;

+(SerializationComplexEntities*) sharedSerializer;

@end
