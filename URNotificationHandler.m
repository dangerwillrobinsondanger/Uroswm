/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-21 13:34:47 +0200 by Alex Sangiuliano

*/

#import "URNotificationHandler.h"
#import "URWindow.h"

@implementation URNotificationHandler

-(id)initWithDisplay:(Display*)disp
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    display = disp;
    return self;
}

- (void) handleCreateNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Create event to handle: %d", theEvent.type);
    /*XCreateWindowEvent createEvent = theEvent.xcreatewindow;
    Window parentWin = createEvent.window;
    NSLog(@"Intero abbestia %lu", parentWin);
    Window win = XCreateSimpleWindow(display,parentWin,0,0,200,200,0,0,0);
    XMapWindow(display,win);
    XFlush(display);*/
}

- (void) handleDestroyNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Destroy event to handle: %d", theEvent.type);
}

- (void) handleReparentNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Reparent event to handle: %d", theEvent.type);
}

- (void) handleMapRequestEvent:(XEvent)theEvent
{
    XMapRequestEvent mapRequestEvent = theEvent.xmaprequest;
    URWindow *win = [[URWindow alloc] initWithXWindow:mapRequestEvent.window display:display];
    [win mapWindow];
    //XFlush(display); seems unnecessary
}

- (void) handleConfigureRequestEvent:(XEvent)theEvent
{
    XConfigureRequestEvent configureRequestEvent = theEvent.xconfigurerequest;
    URWindow *win = [[URWindow alloc] initWithXWindow:configureRequestEvent.window display:display];
    XWindowChanges xWinChanges;
    xWinChanges.x = configureRequestEvent.x;
    xWinChanges.y = configureRequestEvent.y;
    xWinChanges.width = configureRequestEvent.width;
    xWinChanges.height = configureRequestEvent.height;
    xWinChanges.border_width = configureRequestEvent.border_width;
    xWinChanges.sibling = configureRequestEvent.above;
    xWinChanges.stack_mode = configureRequestEvent.detail;
    XConfigureWindow(display,[win xWindow],configureRequestEvent.value_mask,&xWinChanges);
}

@end
