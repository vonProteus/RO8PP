//
//  NSMutableArray+Stack.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)
-(void) push:(id)anObject;
-(id) pop;

@end
