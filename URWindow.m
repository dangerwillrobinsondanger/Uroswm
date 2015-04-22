/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-12 10:21:47 +0200 by Alex Sangiuliano

*/

#import "URWindow.h"

@implementation URWindow

-(id)initWithXWindow:(Window)win display:(Display*)display
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    framed = NO;
    xWindow = win;
    dpy = display;
    rootWindow = RootWindow(dpy, DefaultScreen(dpy));
    
    if (framed == NO)
        [self createFrameForWindow:self];
    return self;
}

- (void) mapWindow
{
    XMapWindow(dpy,xWindow);
}

- (Window) xWindow
{
    return xWindow;
}

-(Window) frameWindow
{
    return frameWindow;
}

-(void)createFrameForWindow:(URWindow*)window
{
    unsigned int BORDER_WIDTH = 3;
    unsigned long BORDER_COLOR = 0xff0000;
    unsigned long BG_COLOR = 0x0000ff;
    
    XWindowAttributes windowAttributes;
    XGetWindowAttributes(dpy, [window xWindow], &windowAttributes);
    frameWindow = XCreateSimpleWindow(dpy,rootWindow,windowAttributes.x,
                                                     windowAttributes.y,
                                                     windowAttributes.width,
                                                     windowAttributes.height,
                                                     BORDER_WIDTH,
                                                     BORDER_COLOR,
                                                     BG_COLOR);
    XSelectInput(dpy,frameWindow,SubstructureRedirectMask | SubstructureNotifyMask);
    XAddToSaveSet(dpy, [window xWindow]);
    //reparenting the xWindow to frameWindow
    XReparentWindow(dpy,[window xWindow],frameWindow,0, 0);
    XMapWindow(dpy, frameWindow);
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
    framed = YES;
}
@end