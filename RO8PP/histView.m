//
//  histView.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "histView.h"

@implementation histView
@synthesize dict;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.dict == nil) {
        DLog(@"error: dict nil\n");
        return;
    }
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    

    [self drawlineFromArry:[dict valueForKey:@"red"] withColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:0.6]];
    [self drawlineFromArry:[dict valueForKey:@"green"] withColor:[NSColor colorWithDeviceRed:0 green:1 blue:0 alpha:0.6]];
    [self drawlineFromArry:[dict valueForKey:@"blue"] withColor:[NSColor colorWithDeviceRed:0 green:0 blue:1 alpha:0.6]];
    [self drawlineFromArry:[dict valueForKey:@"gray"] withColor:[NSColor grayColor]];
    

    // Drawing code here.
}

-(int) value0255From:(int)inVal 
                 Min:(int)min
                 Max:(int)max{
    double outVal = 0;
    double up = (inVal - min);
    double down = (max - min);
    
    outVal = (up/down)*255.0;
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"inVal: %i min: %i max:%i outVal: %f up: %f down: %f\n", inVal, min, max, outVal, up, down];
//        DLog(@"%@",stringTMP);
//    }
    
    
    
    return (int)outVal;
}

-(void) drawlineFromArry:(NSArray*)array1 
               withColor:(NSColor*)rgba{
//    DLog(@"test: start\n");
    Segmentation* sTMP = [[Segmentation alloc] init];
    NSMutableArray* array = [array1 mutableCopy];
    [array removeObjectAtIndex:0];
    [array removeLastObject];
    int min = (int)[sTMP minFrom:array];
    int max = (int)[sTMP maxFrom:array];
    NSBezierPath* path = [[NSBezierPath alloc] init];
    [path moveToPoint:NSMakePoint(-1, 0)];
    for (int a = 0; a < [array count]; ++a) {
        NSNumber* num = [array objectAtIndex:a];
        double val = [self value0255From:(int)[num doubleValue] Min:min Max:max];
//        {
//            NSString* stringTMP = [NSString stringWithFormat:@"orgVal=%i(int) %f(double) min=%i max=%i val=%f\n", [num intValue], [num doubleValue], min, max, val];
//             DLog(@"%@",stringTMP);
//        }

        NSPoint tmp = NSMakePoint(a, val);
//        {
//            NSString* stringTMP = [NSString stringWithFormat:@"line to x: %f y: %f\n", tmp.x, tmp.y];
//            DLog(@"%@",stringTMP);
//        }

        [path lineToPoint:tmp];
    }
    [rgba set];
    [path lineToPoint:NSMakePoint(256, -1)];
    [rgba setFill];
    [path fill];
    
    [path stroke];
//    DLog(@"test: end\n");
    
}

@end
