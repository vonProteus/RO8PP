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


-(void)hist{
    
    for (int a = 0; a < X; ++a) {
        for (int b = 0; b < Y; ++b) {
        }
    }

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
@end
