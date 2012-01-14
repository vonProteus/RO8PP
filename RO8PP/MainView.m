//
//  MainView.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"


@implementation MainView

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
    // Drawing code here.
}

- (IBAction)openFile:(id)sender
{
    //metode from http://www.xphere.me/old/info/cocoa_tut03/index.html
    
	// "Standard" open file panel
	NSArray *fileTypes = [NSArray arrayWithObjects:@"jpg", @"gif",@"png", @"psd", @"tga", nil];
	
	int i;
	// Create the File Open Panel class.
	NSOpenPanel* oPanel = [NSOpenPanel openPanel];
	//	[oPanel setParentWindow:[sender window]];	// Define the parent of our dialog
	//	[oPanel setFloatingPanel:NO];				// When we move our parent window, the dialog moves with it
	
	[oPanel setCanChooseDirectories:NO];		// Disable the selection of directories in the dialog.
	[oPanel setCanChooseFiles:YES];				// Enable the selection of files in the dialog.
	[oPanel setCanCreateDirectories:YES];		// Enable the creation of directories in the dialog
	[oPanel setAllowsMultipleSelection:NO];		// Allow multiple files selection
	[oPanel setAlphaValue:0.95];				// Alpha value
	[oPanel setTitle:@"Select a file to open"];
	
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [oPanel runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* files = [oPanel filenames];
		
		// Loop through all the files and process them.
		for( i = 0; i < [files count]; i++ )
		{
			NSString* fileName = [files objectAtIndex:i];
			NSLog(fileName);
			
			NSImage *imageFromBundle = [[NSImage alloc] initWithContentsOfFile:fileName];
            image = imageFromBundle;
            
            
            
                     
			if (imageFromBundle !=nil)
			{
				
				[ViewImage setImage: imageFromBundle];
				
				NSRect frame = [MyWindow frame];
				frame.size = [imageFromBundle size];
                
                {
                    NSString* stringTMP = [NSString stringWithFormat:@"H: %f W: %f\n",frame.size.height, frame.size.width];
                    DLog(@"%@",stringTMP);
                }


				frame.size.height += 20;
				
				[MyWindow setFrame:frame display:YES animate:YES];
                helpImage = [[NSImage alloc] init];
                
                NSBitmapImageRep* bmp2 = [[NSBitmapImageRep alloc] initWithData:[imageFromBundle TIFFRepresentation]];
                for (int a = 0; a < [bmp2 pixelsWide]; ++a) {
                    for (int b = 0; b < [bmp2 pixelsHigh]; ++b) {
                        [bmp2 setColor:[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:1] atX:a y:b];
                    }
                }
                NSImage* newHelpImage = [[NSImage alloc] init];
                [newHelpImage addRepresentation:bmp2];
                [helpViewImage setImage:newHelpImage];
                helpImage = newHelpImage;
                
                [self hist:nil];
			}
		}
	}
    DLog(@"test: ok\n");
}

- (void) mouseDown:(NSEvent*)someEvent{
    if (image == nil) {
        return;
    }
     NSPoint location = [self.window convertScreenToBase:[NSEvent mouseLocation]];
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%f %f\n",location.x,location.y];
        DLog(@"%@",stringTMP);
    }

    Segmentation* s = [[Segmentation alloc] init];
    NSImage* newImage = [s floodFillOn:image
                             fromPoint:location
                         withTolerancy:[tolerancySlider integerValue]];
    
    NSImage* newHelpImage = [s addMapTo:helpImage
                              withColor:[NSColor colorWithDeviceRed:(arc4random()%255)/255.0
                                                              green:(arc4random()%255)/255.0
                                                               blue:(arc4random()%255)/255.0
                                                              alpha:0.9]];
    if (newHelpImage ==nil){
        DLog(@"error: nie ma helpImage\n");
    }
    
    
    if (newImage !=nil)
    {
        
        [ViewImage setImage: newImage];
        [helpViewImage setImage: newHelpImage];
        
        NSRect frame = [MyWindow frame];
        frame.size = [newImage size];

        frame.size.height += 20;
        
        [MyWindow setFrame:frame display:YES animate:YES];
    }
    image = newImage;
    helpImage = newHelpImage;
    

}

-(IBAction) valueDidChange:(id)sender{
//    DLog(@"test: ok?\n");
    
    [tolerancyTextField setStringValue:[NSString stringWithFormat:@"tolerancja: %ld", [tolerancySlider integerValue]]];
}

-(IBAction)hist:(id)sender{
    Segmentation* s = [[Segmentation alloc] init];
    NSDictionary* dict = [s hist:image];
    hv.dict = dict;
    int red[256];
    int green[256];
    int blue[256];
    int gray[256];
    int redSum = 0;
    int greenSum = 0;
    int blueSum = 0;
    int graySum = 0;
    
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
    
       
    NSBitmapImageRep* histBMP = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                        pixelsWide:256 
                                                                        pixelsHigh:256
                                                                     bitsPerSample:8
                                                                   samplesPerPixel:4
                                                                          hasAlpha:YES 
                                                                          isPlanar:NO
                                                                    colorSpaceName:@"NSCalibratedRGBColorSpace" 
                                                                       bytesPerRow:0
                                                                      bitsPerPixel:0];
    
    for (int x = 0; x < 256; ++x) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"x:%i R:%i(%i) G:%i(%i) B:%i(%i) Gr:%i(%i) Min:%i Max:%i\n", x, red[x], [self value0255From:red[x] Min:minR Max:maxR], green[x], [self value0255From:green[x] Min:minG Max:maxG], blue[x], [self value0255From:blue[x] Min:minB Max:maxB], gray[x], [self value0255From:gray[x] Min:minGr Max:maxGr], min, max];
            DLog(@"%@",stringTMP);
        }
        
        redSum += red[x];
        greenSum += green[x];
        blueSum += blue[x];
        graySum += gray[x];

        for (int y = 0; y < 256; ++y) {
            [histBMP setColor:[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:0] 
                          atX:x y:y];
            if ([self value0255From:red[x] Min:minR Max:maxR] == y) {
                [histBMP setColor:[NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:1]
                              atX:x y:y];
//                DLog(@"test: red\n");
                
            }
            if ([self value0255From:green[x] Min:minG Max:maxG] == y) {
                [histBMP setColor:[NSColor colorWithDeviceRed:0 green:1 blue:0 alpha:1]
                              atX:x y:y];
            }
            if ([self value0255From:blue[x] Min:minB Max:maxB] == y) {
                [histBMP setColor:[NSColor colorWithDeviceRed:0 green:0 blue:1 alpha:1] 
                              atX:x y:y];
            }
            if ([self value0255From:gray[x] Min:minGr Max:maxGr] == y) {
                
                [histBMP setColor:[NSColor grayColor]
                              atX:x y:y];
            }
            
        }
    }
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"sums R:%i G:%i B:%i Gr:%i all:%f\n", redSum, greenSum, blueSum, graySum, image.size.width*image.size.height];
        DLog(@"%@",stringTMP);
    }

    
    
//    
//    NSImage* newHist = [[NSImage alloc] init];
//    [newHist addRepresentation:histBMP];
//    [histViewImage setImage:newHist];
//    hist = newHist;
    [hv display];
    DLog(@"test: ok\n");
}

-(int) value0255From:(int)inVal 
                 Min:(int)min
                 Max:(int)max{
    int outVal = 0;
    
    outVal = ((double)(inVal - min)/(double)(max - min))*255.0;
    
    
    return outVal;
}

@end
