/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-21 13:34:47 +0200 by Alex Sangiuliano

*/

#import "URNotificationHandler.h"
#import "URWindow.h"
#import "URFrame.h"
#import "URTitleBar.h"

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
}

- (void) handleReparentNotifyEvent:(XEvent)theEvent
{
}

/*- (void) handleMapNotifyEvent:(XEvent)theEvent
{
}*/

- (void) handleMapRequestEvent:(XEvent)theEvent
{
    XMapRequestEvent mapRequestEvent = theEvent.xmaprequest;
    URWindow *win = [[URWindow alloc] initWithXWindow:mapRequestEvent.window display:display];
    URFrame *frameWindow = [[URFrame alloc] initWithDisplay:display];
    URTitleBar *titleBar = [[URTitleBar alloc] initWithDisplay:display];
    [frameWindow createFrameForWindow:win];
    [titleBar createTitleBarForFrame:frameWindow];
    [frameWindow reparentChildWindow:win atX:0 andY:[titleBar height]];
    [win setBrother:titleBar];
    [frameWindow reparentChildWindow:titleBar atX:0 andY:0];
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
   /* URWindow *win = [[URWindow alloc] initWithXWindow:configureRequestEvent.window display:display];*/
    XConfigureWindow(display,configureRequestEvent.window,configureRequestEvent.value_mask,&xWinChanges);
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

    XUnmapWindow(display, [frameWindow xWindow]);
    XReparentWindow(display,unmapNotifyEvent.window,rootWindow,0,0);
    XRemoveFromSaveSet(display,unmapNotifyEvent.window);
    [windowsDict removeObjectForKey:[NSString stringWithFormat:@"%lu",unmapNotifyEvent.window]];
    NSLog(@"Il dizionario è modificato? %@", windowsDict);
}

- (void)handleButtonPressEvent:(XEvent)theEvent
{
    XButtonEvent buttonEvent = theEvent.xbutton;
    URFrame *frameWindow = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",buttonEvent.window]];
    
    if (!frameWindow)
        return;
    //get the mouse starting location
    startMousePosition = NSMakePoint(buttonEvent.x_root, buttonEvent.y_root);
    //now check some geometry and get frame starting position
    int x,y;
    Window reRootWindow; //this is the same of rootWindow;look for better implementation here.
    unsigned width, height, border_width, depth;
    XGetGeometry(display,[frameWindow xWindow],&reRootWindow,&x, &y,&width, &height,&border_width,&depth);
    NSLog(@"Sono la stessa finestra? %d", reRootWindow == rootWindow);
    startFramePosition = NSMakePoint(x,y);
    frameSize = NSMakeSize(width,height);
    
    XRaiseWindow(display, [frameWindow xWindow]);
}

- (void) handleMotionNotifyEvent:(XEvent)theEvent
{
    XMotionEvent motionEvent = theEvent.xmotion;
    URFrame *frameWindow = [windowsDict objectForKey:[NSString stringWithFormat:@"%lu",motionEvent.window]];
    
    if(!frameWindow)
        return;
    
    NSPoint dragPosition = NSMakePoint(motionEvent.x_root,motionEvent.y_root);
    NSPoint delta = [self calculateDeltaPosition:dragPosition startingPosition:startMousePosition];
    
    //move the window
    if (motionEvent.state & Button1Mask)
    {
        NSPoint destPosition = NSMakePoint(startFramePosition.x+delta.x,startFramePosition.y+delta.y);
        XMoveWindow(display,[frameWindow xWindow],destPosition.x, destPosition.y);
    }    
    else if(motionEvent.state & Button3Mask)
    {
        NSPoint deltaSize = NSMakePoint(MAX(delta.x,-frameSize.width), MAX(delta.y,-frameSize.height));
        NSSize finalSize = NSMakeSize(deltaSize.x+frameSize.width,deltaSize.y+frameSize.height);
        XResizeWindow(display,[frameWindow xWindow],finalSize.width, finalSize.height);
        XResizeWindow(display,motionEvent.window,finalSize.width, finalSize.height);
    }
    
}
//if this method is useless I'll remove it
-(NSPoint)calculateDeltaPosition:(NSPoint)dragPosition startingPosition:(NSPoint)startPosition
{
    NSPoint delta = NSMakePoint(dragPosition.x-startPosition.x, dragPosition.y-startPosition.y);
    return delta;
}

@end
