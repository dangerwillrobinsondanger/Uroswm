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
    notificationHandler = [[URNotificationHandler alloc] initWithDisplay:dpy];
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
    NSLog(@"Uroswm: Connected %lu", rootWindow);
    XSetErrorHandler(&handleXError);
    
    //Main run loop
    
    for(;;)
    {
        XEvent anEvent;
        XNextEvent(dpy, &anEvent);
        NSLog(@"Received event %d", anEvent.type);
        
        switch (anEvent.type) 
        {
          case CreateNotify: //16
                   //[notificationHandler handleCreateNotifyEvent:anEvent];
                   break;
          case DestroyNotify: //17
                   //[notificationHandler handleDestroyNotifyEvent:anEvent];
                   break;
          case ReparentNotify: //21
                  // [notificationHandler handleReparentNotifyEvent:anEvent];
                   break;
          case UnmapNotify: //18
                   [notificationHandler handleUnmapNotifyEvent:anEvent];
                   break;
          case MapNotify: //19
                   NSLog(@"Map Notify received! handle it");
                  // [notificationHandler handleMapNotifyEvent:anEvent];
                   break;
          case MapRequest:
                   [notificationHandler handleMapRequestEvent:anEvent];
                   break;
          case ConfigureRequest:
                   [notificationHandler handleConfigureRequestEvent:anEvent];
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

int handleXError(Display *display, XErrorEvent *error)
{
    char error_text[ERROR_LENGTH];
    XGetErrorText(display,error->error_code, error_text, sizeof(error_text));
    NSString *err = [NSString stringWithCString:error_text encoding:NSUTF8StringEncoding];
    NSLog(@"Received X error:");
    NSLog(@"Request number: %d.", error->request_code);
    NSLog(@"Error code: %d, Error string: %@.",error->error_code, err);
    NSLog(@"Resource ID: %lu", error->resourceid);
    return 0; 
}
- (Display*) display
{
    return dpy;
}

@end
