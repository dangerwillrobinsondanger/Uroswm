/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-22 11:42:47 +0200 by Alex Sangiuliano

*/

#import <Foundation/Foundation.h>

#include <X11/Xlib.h>

@interface URWindow : NSObject
{
    Window xWindow;
    Window frameWindow;
    Window rootWindow;
    Display *dpy;
    BOOL framed;
}

-(id)initWithXWindow:(Window)win display:(Display*)display;

//URWindow get attributes.
- (Window) xWindow;
- (Window) frameWindow;

/**
  * This method map the window to the X server, to be shown on the screen
  */
-(void) mapWindow:(URWindow *)window;

/**
 * This method create a frame window, reparenting the window passed as argument
 */
 -(void)createFrameForWindow:(URWindow*)window;
@end