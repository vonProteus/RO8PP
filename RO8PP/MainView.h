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
    NSImage* image;
    NSImage* hist;
}
- (IBAction)openFile:(id)sender;
-(IBAction)hist:(id)sender;
@end
 