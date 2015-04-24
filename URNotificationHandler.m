/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-21 13:34:47 +0200 by Alex Sangiuliano

*/

#import "URNotificationHandler.h"
#import "URWindow.h"
#include <unistd.h>

@implementation URNotificationHandler

-(id)initWithDisplay:(Display*)disp
{
    self = [super init];
    
    if (self == nil)
        return nil;
    
    display = disp;
    windowsDict = [[NSMutableDictionary alloc]init];
    rootWindow = RootWindow(display, DefaultScreen(display));
    return self;
}

-(NSMutableDictionary*)windowsDictionary
{
    return windowsDict;
}

/*- (void) handleCreateNotifyEvent:(XEvent)theEvent
{
    NSLog(@"The Create event to handle: %d", theEvent.type);
    XCreateWindowEvent createEvent = theEvent.xcreatewindow;
    URWindow *win = [[URWindow alloc] initWithXWindow:createEvent.window display:display];
    NSString *key = [NSString stringWithFormat:@"%lu",createEvent.window];
    //[windowsDict setObject:win forKey:key];
}*/

- (void) handleDestroyNotifyEvent:(XEvent)theEvent
{
    NSLog(@"Destroy handleing %@!!", windowsDict);
    XDestroyWindowEvent destroyEvent = theEvent.xdestroywindow;
    URWindow *win = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",destroyEvent.window]];
    if (win == nil)
    {
       NSLog(@"Nil window in destroy");
       return;
    }

    //XUnmapSubwindows(display, [win frameWindow]);
    //XUnmapWindow(display,[win frameWindow]);
    //XReparentWindow(display,[win xWindow],[win rootWindow],0,0);
    XDestroySubwindows(display, [win frameWindow]);
    XDestroyWindow(display, [win frameWindow]);
    [windowsDict removeObjectForKey:[NSString stringWithFormat:@"%lu",destroyEvent.window]];
}

- (void) handleReparentNotifyEvent:(XEvent)theEvent
{
    /*XReparentEvent reparentEvent = theEvent.xreparent;
    URWindow *win = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",reparentEvent.window]];
    XReparentWindow(display,[win xWindow], [win rootWindow],0,0);*/
}

/*- (void) handleMapNotifyEvent:(XEvent)theEvent
/
    NSLog(@"The MapNotify event to handle: %d", theEvent.type);
    XMapEvent mapEvent = theEvent.xmap;
    URWindow *win = [[URWindow alloc] initWithXWindow:mapEvent.window display:display];
    NSString *key = [NSString stringWithFormat:@"%lu",mapEvent.window];
    //[windowsDict setObject:win forKey:key];
}*/

- (void) handleMapRequestEvent:(XEvent)theEvent
{
    XMapRequestEvent mapRequestEvent = theEvent.xmaprequest;
    URWindow *win = [[URWindow alloc] initWithXWindow:mapRequestEvent.window display:display];
    [windowsDict setObject:win forKey:[NSString stringWithFormat:@"%lu",mapRequestEvent.window]];
    [win mapWindow];
    NSLog(@"Il dizionario %@", windowsDict);
}

- (void) handleConfigureRequestEvent:(XEvent)theEvent
{
    XConfigureRequestEvent configureRequestEvent = theEvent.xconfigurerequest;
    URWindow *win = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",configureRequestEvent.window]];

    if (win == nil)
    {
       NSLog(@"Sono nil nel configure");
       win = [[URWindow alloc] initWithXWindow:configureRequestEvent.window display:display];
    }
     
    XWindowChanges xWinChanges;
    xWinChanges.x = configureRequestEvent.x;
    xWinChanges.y = configureRequestEvent.y;
    xWinChanges.width = configureRequestEvent.width;
    xWinChanges.height = configureRequestEvent.height;
    xWinChanges.border_width = configureRequestEvent.border_width;
    xWinChanges.sibling = configureRequestEvent.above;
    xWinChanges.stack_mode = configureRequestEvent.detail;
    XConfigureWindow(display,[win frameWindow],configureRequestEvent.value_mask,&xWinChanges);
    XConfigureWindow(display,[win xWindow],configureRequestEvent.value_mask,&xWinChanges);
}

-(void)handleUnmapNotifyEvent:(XEvent)theEvent
{
    XUnmapEvent unmapNotifyEvent = theEvent.xunmap;
    URWindow *win = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",unmapNotifyEvent.window]];
    
    if (win == nil)
    {
        NSLog(@"NULL WINDOW");
        return;
    }

    if (unmapNotifyEvent.event == rootWindow)
    {
       NSLog(@"Ignore pre-existing reparented window");
       return;
    }
    NSLog(@"i valoru %lu e frame %lu", [win xWindow], [win frameWindow]);
    XUnmapWindow(display, [win frameWindow]);
    //XReparentWindow(display,[win xWindow],rootWindow,0,0);
    XRemoveFromSaveSet(display,[win xWindow]);
    XDestroyWindow(display, [win frameWindow]);
    [windowsDict removeObjectForKey:[NSString stringWithFormat:@"%lu",unmapNotifyEvent.window]];
    NSLog(@"Il dizionario è modificato? %@", windowsDict);
}

@end
