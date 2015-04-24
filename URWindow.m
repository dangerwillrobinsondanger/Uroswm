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
    return self;
}

- (void) mapWindow
{
    XMapWindow(dpy,xWindow);
}

- (void) unmapWindow
{
    XUnmapWindow(dpy,xWindow);
}

- (Window) xWindow
{
    return xWindow;
}

- (Window) rootWindow
{
    return rootWindow;
}
@end
