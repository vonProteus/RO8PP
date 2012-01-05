//
//  Segmentation.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Segmentation : NSObject{
    
}
-(NSImage*) praireFireOn:(NSImage*)image 
               fromPoint:(NSPoint)start 
           withTolerancy:(NSUInteger)tolerancy;
@end
