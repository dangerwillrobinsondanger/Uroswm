/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-12 10:21:47 +0200 by Alex Sangiuliano

*/

#import "UrosWindowManager.h"

@implementation UrosWindowManager

- (id) init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }

    dpy = XOpenDisplay(NULL);
    screen = DefaultScreen(dpy);
    rootWindow = RootWindow(dpy, screen);
    return self;
}

-(void) RunLoop
{
    if (dpy == NULL)
    {
        return;
    }
    XSetErrorHandler(&checkOthersWM);
    XSelectInput(dpy,rootWindow,SubstructureRedirectMask | SubstructureNotifyMask);
    XSync(dpy,false);
    NSLog(@"Uroswm: Connected");
    
    //Main run loop
    
    for(;;)
    {
        XEvent anEvent;
        XNextEvent(dpy, &anEvent);
        NSLog(@"Received event %d", anEvent.type);
        
        switch (anEvent.type) 
        {
          case CreateNotify:
                   [self handleCreateNotifyEvent:anEvent];
                   break;
          case DestroyNotify:
                   [self handleDestroyNotifyEvent:anEvent];
                   break;
          case ReparentNotify:
                   [self handleReparentNotifyEvent:anEvent];
                   break;
          default:
                   NSLog(@"Event still not handled");
        }
    }
    
}

int checkOthersWM(Display* display, XErrorEvent* error)
{
    if (error != NULL && error->error_code == BadAccess)
    {
        NSLog(@"Uroswm: Another window manager is running!");
        exit(EXIT_FAILURE);
    }
    return 0;
}


- (Display*) display
{
    return dpy;
}

- (void) handleCreateNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Create event to handle: %d", theEvent.type);
}

- (void) handleDestroyNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Destroy event to handle: %d", theEvent.type);
}

- (void) handleReparentNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Reparent event to handle: %d", theEvent.type);
}
@end
