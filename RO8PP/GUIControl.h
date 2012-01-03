/* GUIControl */

#import <Cocoa/Cocoa.h>
//#import <Foundation/Foundation.h>

@interface GUIControl : NSObject{
    IBOutlet NSWindow *MyWindow;
    IBOutlet NSImageView *ViewImage;
    
}
- (IBAction)openFile:(id)sender;
@end
