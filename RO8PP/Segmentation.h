//
//  Segmentation.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Segmentation : NSObject{
    NSColor* targetColor;
    NSBitmapImageRep* bmp;
    BOOL** bmpVizited;
    NSInteger X, Y;
    NSInteger change;
}
@property (nonatomic, assign) NSPoint target;
@property (nonatomic, retain) NSImage* image;
@property (nonatomic, assign) NSUInteger tolerancy;

-(NSImage*) praireFireOn:(NSImage*)image 
               fromPoint:(NSPoint)start 
           withTolerancy:(NSUInteger)tolerancy;

-(void) fillX:(NSInteger)x
            y:(NSInteger)y;

-(NSBitmapImageRep*) grayscaleImageRep:(NSBitmapImageRep*)img;
-(double) grayValueOfColor:(NSColor*)rgba;
-(void) hist;
@end
