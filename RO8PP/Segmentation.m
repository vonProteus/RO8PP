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
    return self;
}

-(NSImage*) praireFireOn:(NSImage *)image2 
               fromPoint:(NSPoint)start 
           withTolerancy:(NSUInteger)tolerancy{
    
    NSBitmapImageRep* bmp = [[NSBitmapImageRep alloc] initWithData:[image2 TIFFRepresentation]];
    NSBitmapImageRep* resultBmp = [self grayscaleImageRep:bmp];
    
    if (resultBmp == nil) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"nil\n"];
            DLog(@"%@",stringTMP);
        }

    }
    
   
    
    NSPoint sizeOfImage = NSMakePoint([bmp pixelsWide], [bmp pixelsHigh]);
        
    if (start.x > sizeOfImage.x) {
        return nil;
    }
    if (start.y > sizeOfImage.y) {
        return nil;
    }
    
    
    {
        
        NSString* stringTMP = [NSString stringWithFormat:@"x %f y %f %@ \n",resultBmp.size.width, resultBmp.size.height, [resultBmp colorAtX:5 y:5]];
        DLog(@"%@",stringTMP);
    }

    
    
    
//    for (NSUInteger x = 0; x < sizeOfImage.x; ++x) {
//        for (NSUInteger y = 0; y < sizeOfImage.y; ++y) {
//            NSColor* rgba = [bmp colorAtX:x
//                                        y:y];
//            
//            CGFloat r, g, b, h, s, br, a, white;
//            r = [rgba redComponent]*255.0;
//            g = [rgba greenComponent]*255.0;
//            b = [rgba blueComponent]*255.0;
//            h = [rgba hueComponent]*360.0;
//            s = [rgba saturationComponent]*100.0;
//            br = [rgba brightnessComponent]*100.0;
//            a = [rgba alphaComponent]*255.0;
////            NSColor* gray = [rgba colorUsingColorSpace:[NSColorSpace genericGrayColorSpace]];
////            white = [gray whiteComponent]*255.0;
//            
////            [bmp setColor:[NSColor colorWithDeviceHue:r/255.0 
////                                           saturation:b/255.0 
////                                           brightness:g/255.0
////                                                alpha:a/255.0] 
////                      atX:x 
////                        y:y];
//            CGFloat comp[] = {white/255.0, a/255.0};
//            NSColor* aColor = gray;            
//            
//            [bmp setColor:aColor
//                      atX:x
//                        y:y];
//        }
//    }

    NSImage* result = [[NSImage alloc] init];
    [result addRepresentation:resultBmp];
    
    return result;
}

- (NSBitmapImageRep*) grayscaleImageRep:(NSBitmapImageRep*) img{
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


@end
