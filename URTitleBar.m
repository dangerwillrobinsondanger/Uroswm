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
    unsigned long BG_COLOR = 0xC0C0C0;
    /*for now load the image in this stupid way.FIXME: use NSSearchPathForDirectoriesInDomains*/
    NSString *imagePath = @"Resources/titleback.xpm";
    
    XWindowAttributes windowAttributes;
    XGetWindowAttributes(dpy, [aFrameWindow xWindow], &windowAttributes);
    height = 16;
    width = windowAttributes.width;
    xWindow = XCreateSimpleWindow(dpy,rootWindow,windowAttributes.x,windowAttributes.y,width,height,1,BORDER_COLOR,BG_COLOR);
    XAddToSaveSet(dpy, [aFrameWindow xWindow]);//generates a badmatch. IS it necessary to add this to the save set?
    [self mapWindow];
    [self setBackgroundImage:imagePath];
    graphicContext = XCreateGC(dpy,xWindow,0,NULL);
    /* ↓ Use XReneder to enlarge the image to fit the whole titlebar window!*/
    
    /*Pixmap pix = XCreatePixmap(dpy,xWindow,backgroundImage->width,backgroundImage->height,XDefaultDepth(dpy,XDefaultScreen(dpy)));
    XPutImage(dpy,pix,graphicContext,backgroundImage,0,0,0,0,backgroundImage->width,backgroundImage->height);
    XSetWindowBackgroundPixmap(dpy, xWindow, pix);*/
    XFlushGC(dpy,graphicContext);
    XFreeGC(dpy,graphicContext);
    //XFreePixmap(dpy,pix);
}
@end
