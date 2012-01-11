//
//  MainView.h
//  RO8PP
//
//  Created by Maciej Krok on 2012-01-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Segmentation.h"

@interface MainView : NSView{
    IBOutlet NSWindow *MyWindow;
    IBOutlet NSImageView *ViewImage;
    IBOutlet NSImageView *helpViewImage;
    NSImage* image;
    NSImage* helpImage;
    IBOutlet NSImageView *histViewImage;
    NSImage* hist;
    IBOutlet NSSlider* tolerancySlider;
    IBOutlet NSTextField* tolerancyTextField;
}
-(IBAction) openFile:(id)sender;
-(IBAction) hist:(id)sender;
-(IBAction) valueDidChange:(id)sender;


-(int) value0255From:(int)inVal 
                 Min:(int)min
                 Max:(int)max;
@end
 