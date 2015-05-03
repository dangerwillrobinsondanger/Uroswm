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
/* FIXME: For now the method return only YES. Check when can return NO on window configure errors.*/
- (BOOL)setBrother:(URWindow*)aBrother
{
    brother = [aBrother xWindow];
    XWindowChanges changes;
    changes.sibling = brother;
    XConfigureWindow(dpy, xWindow, CWSibling, &changes);//then the sanity check
    return YES;
}

-(Window)brother
{
    return brother;    
}

-(int)height
{
    return height;
}

-(int)width
{
    return width;
}
@end
