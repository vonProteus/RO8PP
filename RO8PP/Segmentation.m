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

-(id) init{
    self = [super init];
    self.image = [[NSImage alloc] init];
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
        {
            NSString* stringTMP = [NSString stringWithFormat:@"error nil\n"];
            DLog(@"%@",stringTMP);
        }
        return nil;
    }
    
   
    
    X = [bmp pixelsWide];
    Y = [bmp pixelsHigh];
    start = NSMakePoint(start.x, Y - start.y);    
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
//    targetColor = [NSColor colorWithDeviceWhite:1 alpha:0];
    [self fillX:start.x 
              y:start.y];
    
    free(bmpVizited);
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"zmienionycj %ld\n",change];
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
        [self fillX:x-1 y:y-1];
        [self fillX:x+1 y:y+1];
        [self fillX:x+1 y:y-1];
        [self fillX:x-1 y:y+1];
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
    return [rgba brightnessComponent];
}


@end
