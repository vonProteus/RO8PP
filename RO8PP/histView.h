//
//  histView.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Segmentation.h"
@interface histView : NSView
@property (nonatomic,strong) NSDictionary* dict;
-(int) value0255From:(int)inVal 
                 Min:(int)min
                 Max:(int)max;
-(void) drawlineFromArry:(NSArray*)array
               withColor:(NSColor*)rgba;
@end
