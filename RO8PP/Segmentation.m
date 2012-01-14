//
//  Segmentation.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Segmentation.h"


@implementation Segmentation
@synthesize image;
@synthesize target;
@synthesize tolerancy;
@synthesize map;

-(id) init{
    self = [super init];
    self.image = [[NSImage alloc] init];
    self.map = [[NSImage alloc] init];
    self.target = NSMakePoint(-1, -1);
    self.tolerancy = 0;
    targetColor = [[NSColor alloc] init];
    X = 0;
    Y = 0;
    change = 0;
    return self;
}

-(NSImage*) praireFireOn:(NSImage *)image2 
               fromPoint:(NSPoint)start 
           withTolerancy:(NSUInteger)tolerancy2{
    
    self.tolerancy = tolerancy2;
    bmp = [[NSBitmapImageRep alloc] initWithData:[image2 TIFFRepresentation]];
    
    if (bmp == nil) {
        DLog(@"error: nil\n");
        return nil;
    }
    
   
    
    X = [bmp pixelsWide];
    Y = [bmp pixelsHigh];
    {
        NSString* stringTMP = [NSString stringWithFormat:@"X: %ld Y: %ld\n", X,Y];
        DLog(@"%@",stringTMP);
    }

    start = NSMakePoint(start.x -1, Y - start.y -2);    
    if (start.x > X && start.x >=0) {
        return nil;
    }
    if (start.y > Y && start.y >=0) {
        return nil;
    }

    
   
	

    bmpVizited = (BOOL**)calloc(X, sizeof(BOOL *));
    for(NSInteger i = 0; i < X; ++i) 
		bmpVizited[i] = (BOOL*) calloc(Y, sizeof(BOOL));
    
    for (int a = 0; a < X; ++a) {
        for (int b = 0; b < Y; ++b) {
            bmpVizited[a][b] = NO;
        }
    }
    change = 0;
    
    targetColor = [bmp colorAtX:start.x 
                              y:start.y];
    

    [self fillX:start.x 
              y:start.y];

    
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"zmieniono %ld\n",change];
        DLog(@"%@",stringTMP);
    }

    NSImage* result = [[NSImage alloc] init];
    [result addRepresentation:bmp];
    
    return result;
}

-(void) fillX:(NSInteger)x 
            y:(NSInteger)y{
   
    
    
    if (x >= X || x <= 0) {
        return;
    }
    if (y >= Y || y <= 0) {
        return;
    }
    if (bmpVizited[x][y]) {
        return;
    }
    bmpVizited[x][y] = YES;


    NSColor* colorXY = [bmp colorAtX:x 
                                   y:y];
    CGFloat w = [self grayValueOfColor:colorXY];
    CGFloat t = [self grayValueOfColor:targetColor];
    
    if (w >= t-self.tolerancy/255.0 && w <= t+self.tolerancy/255.0) {
        ++change;
        [bmp setColor:[NSColor greenColor] 
                  atX:x 
                    y:y];
//        [self fillX:x-1 y:y-1];
//        [self fillX:x+1 y:y+1];
//        [self fillX:x+1 y:y-1];
//        [self fillX:x-1 y:y+1];
        
//        [self fillX:x y:y-1];
//        [self fillX:x y:y+1];
//        [self fillX:x+1 y:y];
//        [self fillX:x-1 y:y];
        
        [stack push:[NSValue valueWithPoint:NSMakePoint(x, y-1)]];
        [stack push:[NSValue valueWithPoint:NSMakePoint(x, y+1)]];
        [stack push:[NSValue valueWithPoint:NSMakePoint(x+1, y)]];
        [stack push:[NSValue valueWithPoint:NSMakePoint(x-1, y)]];
    }
    
}





-(NSBitmapImageRep*) grayscaleImageRep:(NSBitmapImageRep*)img{
    unsigned char *pixels = [img bitmapData];
    
    NSInteger row;
    NSInteger column;
    NSInteger widthInPixels;
    NSInteger heightInPixels;
    
    NSInteger bytesPerRow = [img bytesPerRow];
    NSInteger bytesPerPixel = [img bitsPerPixel] / [img bitsPerSample];
    
    // check if the source imageRep is valid
    
    widthInPixels = [img pixelsWide];
    heightInPixels = [img pixelsHigh];
    
    NSBitmapImageRep *destImageRep = [[NSBitmapImageRep alloc]
                                      initWithBitmapDataPlanes:nil
                                      pixelsWide:widthInPixels
                                      pixelsHigh:heightInPixels
                                      bitsPerSample:8
                                      samplesPerPixel:1
                                      hasAlpha:NO
                                      isPlanar:NO
                                      
                                      colorSpaceName:NSCalibratedWhiteColorSpace
                                      bytesPerRow:widthInPixels
                                      bitsPerPixel:8];
    unsigned char *grayPixels = [destImageRep bitmapData];
    
    for (row = 0; row < heightInPixels; row++){
        unsigned char *sourcePixel = pixels + row*bytesPerRow;
        unsigned char *thisgrayPixel = grayPixels + row*widthInPixels;
        
        for (column = 0; column < widthInPixels; column++,
             sourcePixel+= bytesPerPixel){
            int gray = (77* sourcePixel[0] + 150* sourcePixel[1] +
                        29* sourcePixel[2])/256;
            /*
             77/256 = 0.30078 should be 0.299
             150/256 = 0.58594 should be 0.587
             29/256 = 0.11328 should be 0.114
             JEPG (independent Jpeg Group) uses this:
             Y  =  0.29900 * R + 0.58700 * G + 0.11400 * B
             */
            if( gray>255 ) gray = 255;    // be cautious
            thisgrayPixel[column] = gray;
        }
    }
    return destImageRep;
}

-(double)grayValueOfColor:(NSColor *)rgba{
//    return [rgba brightnessComponent];
    double a = [rgba alphaComponent];
    double r = [rgba redComponent];
    double g = [rgba greenComponent];
    double b = [rgba blueComponent];
    
    return sqrt(r*r + g*g + b*b);
}


-(NSDictionary*) hist:(NSImage *)im{
    bmp = [[NSBitmapImageRep alloc] initWithData:[im TIFFRepresentation]];
    
    if (bmp == nil) {
        DLog(@"error: nil\n");
        return nil;
    }
        
    X = [bmp pixelsWide];
    Y = [bmp pixelsHigh];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSMutableArray* red = [[NSMutableArray alloc] init];
    NSMutableArray* green = [[NSMutableArray alloc] init];
    NSMutableArray* blue = [[NSMutableArray alloc] init];
    NSMutableArray* gray = [[NSMutableArray alloc] init];
    
    for (int a = 0; a < 256; ++a) {
        [red addObject:[NSNumber numberWithInt:0]];
        [green addObject:[NSNumber numberWithInt:0]];
        [blue addObject:[NSNumber numberWithInt:0]];
        [gray addObject:[NSNumber numberWithInt:0]];
    }
    
    
    
    for (int x = 0; x < X; ++x) {
        for (int y = 0; y < Y; ++y) {
            NSColor* rgba = [bmp colorAtX:x y:y];
            int r = [rgba redComponent]*255.0;
            int g = [rgba greenComponent]*255.0;
            int b = [rgba blueComponent]*255.0;
            int gr = [self grayValueOfColor:rgba];//*255.0;
//            {
//                NSString* stringTMP = [NSString stringWithFormat:@"r: %i g: %i b: %i gr %i\n", r, g, b, gr];
//                DLog(@"%@",stringTMP);
//            }

            
            [red replaceObjectAtIndex:r withObject:[NSNumber numberWithInt:[[red objectAtIndex:r] intValue]+1]];
            [green replaceObjectAtIndex:g withObject:[NSNumber numberWithInt:[[green objectAtIndex:g] intValue]+1]];
            [blue replaceObjectAtIndex:b withObject:[NSNumber numberWithInt:[[blue objectAtIndex:b] intValue]+1]];
            [gray replaceObjectAtIndex:gr withObject:[NSNumber numberWithInt:[[gray objectAtIndex:gr] intValue]+1]];
        }
    }
    
    NSMutableArray* tmpMinMax = [[NSMutableArray alloc] init];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self minFrom:red]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self minFrom:green]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self minFrom:blue]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self minFrom:gray]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self maxFrom:red]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self maxFrom:green]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self maxFrom:blue]]];
    [tmpMinMax addObject:[NSNumber numberWithInt:(int)[self maxFrom:gray]]];
    
    int min = [self minFrom:tmpMinMax];
    int max = [self maxFrom:tmpMinMax];
    
    [dict setValue:red forKey:@"red"];
    [dict setValue:green forKey:@"green"];
    [dict setValue:blue forKey:@"blue"];
    [dict setValue:gray forKey:@"gray"];
    [dict setValue:[NSNumber numberWithInt:min] forKey:@"min"];
    [dict setValue:[NSNumber numberWithInt:max] forKey:@"max"];
    
    [dict setValue:[NSNumber numberWithInt:(int)[self minFrom:red]] forKey:@"minR"];
    [dict setValue:[NSNumber numberWithInt:(int)[self maxFrom:red]] forKey:@"maxR"];
    
    [dict setValue:[NSNumber numberWithInt:(int)[self minFrom:green]] forKey:@"minG"];
    [dict setValue:[NSNumber numberWithInt:(int)[self maxFrom:green]] forKey:@"maxG"];
    
    [dict setValue:[NSNumber numberWithInt:(int)[self minFrom:blue]] forKey:@"minB"];
    [dict setValue:[NSNumber numberWithInt:(int)[self maxFrom:blue]] forKey:@"maxB"];
    
    [dict setValue:[NSNumber numberWithInt:(int)[self minFrom:gray]] forKey:@"minGr"];
    [dict setValue:[NSNumber numberWithInt:(int)[self maxFrom:gray]] forKey:@"maxGr"];
        
    return dict;
}

-(NSImage*) addMapTo:(NSImage *)imageToMap 
           withColor:(NSColor *)rgba{
//    NSBitmapImageRep* mapBmp = [[NSBitmapImageRep alloc] initWithData:[map TIFFRepresentation]];
    NSBitmapImageRep* imageToMapBmp = [[NSBitmapImageRep alloc] initWithData:[imageToMap TIFFRepresentation]];
    
    for (NSInteger x = 0; x < X; ++x) {
        for (NSInteger y = 0; y < Y; ++y) {
            if (bmpVizited[x][y]) {
                [imageToMapBmp setColor:rgba 
                                    atX:x y:y];
//                DLog(@"test: byl czarny\n");
            }
        }
    }
    
    NSImage* result = [[NSImage alloc] init];
    [result addRepresentation:imageToMapBmp];
    
    return result;
    
}

-(void) dealloc{
    free(bmpVizited);
}




-(NSImage*) floodFillOn:(NSImage *)image2
              fromPoint:(NSPoint)start 
          withTolerancy:(NSUInteger)tolerancy2{
    
    
    self.tolerancy = tolerancy2;
    bmp = [[NSBitmapImageRep alloc] initWithData:[image2 TIFFRepresentation]];
    
    if (bmp == nil) {
        DLog(@"error: nil\n");
        return nil;
    }
    
    
    
    X = [bmp pixelsWide];
    Y = [bmp pixelsHigh];
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"X: %ld Y: %ld\n", X,Y];
//        DLog(@"%@",stringTMP);
//    }
    
    start = NSMakePoint(start.x -1, Y - start.y -2);    
    if (start.x > X && start.x >=0) {
        return nil;
    }
    if (start.y > Y && start.y >=0) {
        return nil;
    }
    
    
    bmpVizited = (BOOL**)calloc(X, sizeof(BOOL *));
    for(NSInteger i = 0; i < X; ++i) 
		bmpVizited[i] = (BOOL*) calloc(Y, sizeof(BOOL));
    
    for (int a = 0; a < X; ++a) {
        for (int b = 0; b < Y; ++b) {
            bmpVizited[a][b] = NO;
        }
    }

    
    
    
	change = 0;
    
    targetColor = [bmp colorAtX:start.x 
                              y:start.y];
    
    stack = [[NSMutableArray alloc] init];
    
    NSValue* aValue = [NSNumber valueWithPoint:start];
    
    [stack push:aValue];
    
    while ([stack count] != 0) {
        NSPoint p = [[stack pop] pointValue];
        [self fillX:p.x y:p.y];
    }
    
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"zmieniono %ld\n",change];
        DLog(@"%@",stringTMP);
    }
    
    NSImage* result = [[NSImage alloc] init];
    [result addRepresentation:bmp];
    
    DLog(@"test: end\n");
    return result;

    

    
}




-(int) minFrom:(NSArray *)a{
    int min = [[a objectAtIndex:0] intValue];
    for (int b = 1; b < [a count]; ++b) {
        int tmp = [[a objectAtIndex:b] intValue];
        if (min > tmp){
            min = tmp;
        }
    }
    
    return min;
}

-(int) maxFrom:(NSArray *)a{
    int max = [[a objectAtIndex:0] intValue];
    for (int b = 1; b < [a count]; ++b) {
        int tmp = [[a objectAtIndex:b] intValue];
        if (max < tmp){
            max = tmp;
        }
    }
    
    return max;
}
@end
