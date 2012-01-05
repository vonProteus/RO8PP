//
//  Segmentation.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Segmentation.h"

@implementation Segmentation

-(NSImage*) praireFireOn:(NSImage *)image 
               fromPoint:(NSPoint)start 
           withTolerancy:(NSUInteger)tolerancy{
    
    NSBitmapImageRep* bmp = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
    NSColor* black = [NSColor blackColor];
    NSPoint sizeOfImage = NSMakePoint([bmp pixelsWide], [bmp pixelsHigh]);
        
    if (start.x > sizeOfImage.x) {
        return nil;
    }
    if (start.y > sizeOfImage.y) {
        return nil;
    }
    
    for (NSUInteger x = 0; x < sizeOfImage.x; ++x) {
        for (NSUInteger y = 0; y < sizeOfImage.y; ++y) {
            NSColor* rgba = [bmp colorAtX:x
                                        y:y];
            
            CGFloat r, g, b, h, s, br, a;
            r = [rgba redComponent]*255.0;
            g = [rgba greenComponent]*255.0;
            b = [rgba blueComponent]*255.0;
            h = [rgba hueComponent]*360.0;
            s = [rgba saturationComponent]*100.0;
            br = [rgba brightnessComponent]*100.0;
            a = [rgba alphaComponent]*255.0;
            
            
            [bmp setColor:[NSColor colorWithDeviceHue:r/255.0 
                                           saturation:b/255.0 
                                           brightness:g/255.0
                                                alpha:a/255.0] 
                      atX:x 
                        y:y];
            
        }
    }

    NSImage* result = [[NSImage alloc] init];
    [result addRepresentation:bmp];
    return result;
}

@end
