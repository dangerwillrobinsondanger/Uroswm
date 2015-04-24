/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-21 13:34:47 +0200 by Alex Sangiuliano

*/

#import "URNotificationHandler.h"
#import "URWindow.h"
#import "URFrame.h"
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
    //XDestroyWindow(display, [win frameWindow]);
    //XDestroyWindow(display, [win frameWindow]);
    //[windowsDict removeObjectForKey:[NSString stringWithFormat:@"%lu",destroyEvent.window]];
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
    URFrame *frameWindow = [[URFrame alloc] initWithDisplay:display];
    [frameWindow createFrameForWindow:win];
    [windowsDict setObject:frameWindow forKey:[NSString stringWithFormat:@"%lu",[win xWindow]]];
    [win mapWindow];
    NSLog(@"Il dizionario %@", windowsDict);
}

- (void) handleConfigureRequestEvent:(XEvent)theEvent
{
    XConfigureRequestEvent configureRequestEvent = theEvent.xconfigurerequest;
    URFrame *frameWindow = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",configureRequestEvent.window]];
    
    XWindowChanges xWinChanges;
    xWinChanges.x = configureRequestEvent.x;
    xWinChanges.y = configureRequestEvent.y;
    xWinChanges.width = configureRequestEvent.width;
    xWinChanges.height = configureRequestEvent.height;
    xWinChanges.border_width = configureRequestEvent.border_width;
    xWinChanges.sibling = configureRequestEvent.above;
    xWinChanges.stack_mode = configureRequestEvent.detail;
    
    if (frameWindow != nil)
    {
        XConfigureWindow(display, [frameWindow xWindow], configureRequestEvent.value_mask, &xWinChanges);
    }
    //possible errors
    URWindow *win = [[URWindow alloc] initWithXWindow:configureRequestEvent.window display:display];
    XConfigureWindow(display,[win xWindow],configureRequestEvent.value_mask,&xWinChanges);
}

-(void)handleUnmapNotifyEvent:(XEvent)theEvent
{
    XUnmapEvent unmapNotifyEvent = theEvent.xunmap;
    URFrame *frameWindow = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",unmapNotifyEvent.window]];
    
    if (frameWindow == nil)
    {
        NSLog(@"NULL WINDOW");
        return;
    }

    if (unmapNotifyEvent.event == rootWindow)
    {
       NSLog(@"Ignore pre-existing reparented window");
       return;
    }
    //NSLog(@"i valoru %lu e frame %lu", [win xWindow], [win frameWindow]);
    XUnmapWindow(display, [frameWindow xWindow]);
    XReparentWindow(display,unmapNotifyEvent.window,rootWindow,0,0);
    //sleep(5);
    //XMapWindow(display,[win frameWindow]);
    XRemoveFromSaveSet(display,unmapNotifyEvent.window);
    //XDestroyWindow(display, [win frameWindow]);
    //NSLog(@"destroyed? %lu e frame %lu", [win xWindow], [win frameWindow]);
    [windowsDict removeObjectForKey:[NSString stringWithFormat:@"%lu",unmapNotifyEvent.window]];
    NSLog(@"Il dizionario è modificato? %@", windowsDict);
}

@end
