/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-05-2 12:12:08 +0200 by Alex Sangiuliano

*/

#import "URTitleBar.h"

#include <X11/Xlib.h>

@implementation URTitleBar

-(void)setTitle:(NSMutableString*)aTitle
{
    title = aTitle;
}

-(NSMutableString*)title
{
    return title;
}

-(void)createTitleBarForFrame:(URFrame*)aFrameWindow
{
    unsigned long BORDER_COLOR = 0xff0000;
    unsigned long BG_COLOR = 0x0000ff;
    
    XWindowAttributes windowAttributes;
    XGetWindowAttributes(dpy, [aFrameWindow xWindow], &windowAttributes);
    height = 10;
    xWindow = XCreateSimpleWindow(dpy,rootWindow,windowAttributes.x,windowAttributes.y,windowAttributes.width,height,1,BORDER_COLOR,BG_COLOR);
    XAddToSaveSet(dpy, [aFrameWindow xWindow]);
    [self mapWindow];
}
@end