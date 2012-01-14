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
    
    int red[256];
    int green[256];
    int blue[256];
    int gray[256];
    int min = [[dict valueForKey:@"min"] intValue];
    int max = [[dict valueForKey:@"max"] intValue];
    
    int minR = [[dict valueForKey:@"minR"] intValue];
    int maxR = [[dict valueForKey:@"maxR"] intValue];
    
    int minG = [[dict valueForKey:@"minG"] intValue];
    int maxG = [[dict valueForKey:@"maxG"] intValue];
    
    int minB = [[dict valueForKey:@"minB"] intValue];
    int maxB = [[dict valueForKey:@"maxB"] intValue];
    
    int minGr = [[dict valueForKey:@"minGr"] intValue];
    int maxGr = [[dict valueForKey:@"maxGr"] intValue];
    
    for (int a = 0; a < 256; ++a) {
        red[a] = [[[dict valueForKey:@"red"] objectAtIndex:a] intValue];
        green[a] = [[[dict valueForKey:@"green"] objectAtIndex:a] intValue];
        blue[a] = [[[dict valueForKey:@"blue"] objectAtIndex:a] intValue];
        gray[a] = [[[dict valueForKey:@"gray"] objectAtIndex:a] intValue];
    }

    [self drawlineFromArry:[dict valueForKey:@"red"] withColor:[NSColor redColor]];
    [self drawlineFromArry:[dict valueForKey:@"green"] withColor:[NSColor greenColor]];
    [self drawlineFromArry:[dict valueForKey:@"blue"] withColor:[NSColor blueColor]];
    [self drawlineFromArry:[dict valueForKey:@"grayred"] withColor:[NSColor grayColor]];
    
//    NSBeep();
//    
//    NSBezierPath* path = [[NSBezierPath alloc] init];
//    [path moveToPoint:NSMakePoint(0, 0)];
//    [path lineToPoint:NSMakePoint(255, 2*255)];
//    [[NSColor yellowColor] set];
//    
//    [path stroke];

    // Drawing code here.
}

-(int) value0255From:(int)inVal 
                 Min:(int)min
                 Max:(int)max{
    double outVal = 0;
    double up = log2(inVal - min);
    double down = log2(max - min);
    
    outVal = (up/down)*255.0;
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"inVal: %i min: %i max:%i outVal: %f up: %f down: %f\n", inVal, min, max, outVal, up, down];
//        DLog(@"%@",stringTMP);
//    }
    
    
    
    return (int)outVal;
}

-(void) drawlineFromArry:(NSArray*)array 
               withColor:(NSColor*)rgba{
    DLog(@"test: start\n");
    Segmentation* sTMP = [[Segmentation alloc] init];
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
        {
            NSString* stringTMP = [NSString stringWithFormat:@"line to x: %f y: %f\n", tmp.x, tmp.y];
            DLog(@"%@",stringTMP);
        }

        [path lineToPoint:tmp];
    }
    [rgba set];
    
    [path stroke];
    DLog(@"test: end\n");
    
}

@end
