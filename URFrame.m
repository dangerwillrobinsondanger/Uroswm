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
    
    return self;
    
}

-(void)createFrameForWindow:(URWindow*)window
{
    unsigned int BORDER_WIDTH = 3;
    unsigned long BORDER_COLOR = 0xff0000;
    unsigned long BG_COLOR = 0x0000ff;
    
    XWindowAttributes windowAttributes;
    XGetWindowAttributes(dpy, [window xWindow], &windowAttributes);
    xWindow = XCreateSimpleWindow(dpy,rootWindow,windowAttributes.x,
                                                     windowAttributes.y,
                                                     windowAttributes.width,
                                                     windowAttributes.height,
                                                     BORDER_WIDTH,
                                                     BORDER_COLOR,
                                                     BG_COLOR);
    XSelectInput(dpy,xWindow,SubstructureRedirectMask | SubstructureNotifyMask);
    XAddToSaveSet(dpy, [window xWindow]);
    //reparenting the xWindow to frameWindow
    XReparentWindow(dpy,[window xWindow],xWindow,0, 0);
    [self mapWindow];
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

@end