//
//  MainView.m
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#define MAX_WIDTH 800
#define MAX_HEIGHT 600

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
//				if (frame.size.width >= MAX_WIDTH)
//					frame.size.width = MAX_WIDTH;
//				if (frame.size.height >= MAX_HEIGHT)
//					frame.size.height = MAX_HEIGHT;
				frame.size.height += 20;
				
				[MyWindow setFrame:frame display:YES animate:YES];
			}
		}
	}
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
    NSImage* newImage = [s praireFireOn:image
                              fromPoint:location
                          withTolerancy:1];
    if (newImage !=nil)
    {
        
        [ViewImage setImage: newImage];
        
        NSRect frame = [MyWindow frame];
        frame.size = [newImage size];
//        if (frame.size.width >= MAX_WIDTH)
//            frame.size.width = MAX_WIDTH;
//        if (frame.size.height >= MAX_HEIGHT)
//            frame.size.height = MAX_HEIGHT;
        frame.size.height += 20;
        
        [MyWindow setFrame:frame display:YES animate:YES];
    }
    image = newImage;

}

@end
