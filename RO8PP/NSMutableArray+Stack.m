//
//  NSMutableArray+Stack.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

-(void) push:(id)anObject{
    [self addObject:anObject];
}

-(id) pop{
    id toReturn = [self lastObject];
    [self removeLastObject];
    return toReturn;
}

@end
