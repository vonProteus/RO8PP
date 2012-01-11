//
//  Segmentation.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Stack.h"

@interface Segmentation : NSObject{
    NSColor* targetColor;
    NSBitmapImageRep* bmp;
    BOOL** bmpVizited;
    NSInteger X, Y;
    NSInteger change;
    NSMutableArray* stack;
}
@property (nonatomic, assign) NSPoint target;
@property (nonatomic, strong) NSImage* image;
@property (nonatomic, strong) NSImage* map;
@property (nonatomic, assign) NSUInteger tolerancy;

-(NSImage*) addMapTo:(NSImage*)imageToMap 
           withColor:(NSColor*)rgba;

-(NSImage*) floodFillOn:(NSImage*)image 
              fromPoint:(NSPoint)start 
          withTolerancy:(NSUInteger)tolerancy;

-(void) fillX:(NSInteger)x
            y:(NSInteger)y;

-(NSBitmapImageRep*) grayscaleImageRep:(NSBitmapImageRep*)img;
-(double) grayValueOfColor:(NSColor*)rgba;
-(NSDictionary*) hist:(NSImage*)im;

-(int) minFrom:(NSArray*)a;
-(int) maxFrom:(NSArray*)a;
@end
