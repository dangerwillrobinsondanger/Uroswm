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
    Window rootWindow;
    Window brother;
    Display *dpy;
    BOOL framed;
    XImage *backgroundImage;
    GC graphicContext;
    
    int width, height;
}

-(id)initWithXWindow:(Window)win display:(Display*)display;

//URWindow get attributes.
- (Window) xWindow;
- (Window) rootWindow;

/**
  * This method map the window to the X server, to be shown on the screen
  */
-(void) mapWindow;

/**
 * This method unmap the X window
 */
-(void) unmapWindow;
 
 /**
  * This method configures a window using
  */
//-(void)configureWindow:(URWindow*)win display:(Display*)disp;
/**
  *This method set the brother of a window. Look at Xlib manual for: "sibling window"
 * Return YES if the brother is successfully set; NO otherwise
 */
-(BOOL)setBrother:(URWindow*)aBrother;
/**
  * Returns the brother window
  */
-(Window)brother;

/** Returns the height of the window */
-(int)height;
/** Returns the width of the window */
-(int)width;

-(void)setBackgroundImage:(NSString*)imagePath;
-(XImage*)backgroundImage;
@end
