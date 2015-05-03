/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-24 17:08:08 +0200 by Alex Sangiuliano

*/

#import "URFrame.h"

@implementation URFrame

-(id)initWithDisplay:(Display*)display
{
    
    self = [super initWithXWindow:0 display:display];
    
    if (self == nil)
        return nil;
    
    children = [[NSMutableDictionary alloc] init];
    return self;
    
}

-(void)createFrameForWindow:(URWindow*)window
{
    unsigned int BORDER_WIDTH = 3;
    unsigned long BORDER_COLOR = 0xff0000;
    unsigned long BG_COLOR = 0x0000ff;
    
    XWindowAttributes windowAttributes;
    XGetWindowAttributes(dpy, [window xWindow], &windowAttributes);
    width = windowAttributes.width;
    height = windowAttributes.height+10;
    
    xWindow = XCreateSimpleWindow(dpy,rootWindow,windowAttributes.x,
                                                     windowAttributes.y,
                                                     width,
                                                     height,
                                                     BORDER_WIDTH,
                                                     BORDER_COLOR,
                                                     BG_COLOR);
    XSelectInput(dpy,xWindow,SubstructureRedirectMask | SubstructureNotifyMask);
    XAddToSaveSet(dpy, [window xWindow]);
    //Move window alt + left click;
    XGrabButton(dpy,
            Button1,
            Mod1Mask,
    [window xWindow],
               false, ButtonPressMask | ButtonReleaseMask | ButtonMotionMask,
       GrabModeAsync,
       GrabModeAsync,
                None,
               None);
    //Resize window alt + right click
     XGrabButton(dpy,
             Button3,
            Mod1Mask,
    [window xWindow],
               false,ButtonPressMask | ButtonReleaseMask | ButtonMotionMask,
       GrabModeAsync,
       GrabModeAsync,
                None,
               None);
}

-(void)reparentChildWindow:(URWindow*)win atX:(int)x andY:(int)y
{
    //this check can be wrong.Look better!
    if (win == 0)
        return;
    
    XReparentWindow(dpy,[win xWindow],xWindow,x, y);
    [children setObject:win forKey:[NSNumber numberWithInt:[win xWindow]]];
    [self mapWindow];
    
}

-(NSDictionary*)children
{
    return children;
}
@end