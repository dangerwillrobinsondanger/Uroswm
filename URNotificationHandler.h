/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-21 13:34:47 +0200 by Alex Sangiuliano

*/

/**
* This class has the purpose to handle the X notifications, like CreateNotify, 
* DestroyNotify, MotionNoify and so on.
*/

#ifndef _URNOTIFICATIONHANDLER_H_
#define _URNOTIFICATIONHANDLER_H_

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <X11/Xlib.h>

@interface URNotificationHandler : NSObject
{
    Display *display;
    NSMutableDictionary *windowsDict;
    Window rootWindow;
    
    //mouse positions
    NSPoint startMousePosition;
    //frame position
    NSPoint startFramePosition;
    NSSize frameSize;
    //NSWorkspace *workspace;
}

-(id)initWithDisplay:(Display*)disp;

-(NSMutableDictionary*)windowsDictionary;

// Notify handling. These methods could be swtiched to return a BOOL value

//- (void) handleCreateNotifyEvent:(XEvent)theEvent;
- (void) handleDestroyNotifyEvent:(XEvent)theEvent;
- (void) handleReparentNotifyEvent:(XEvent)theEvent;
//- (void) handleMapNotifyEvent:(XEvent)theEvent;
- (void) handleMapRequestEvent:(XEvent)theEvent;
- (void) handleConfigureRequestEvent:(XEvent)theEvent;
- (void) handleUnmapNotifyEvent:(XEvent)theEvent;
- (void) handleButtonPressEvent:(XEvent)theEvent;
- (void) handleMotionNotifyEvent:(XEvent)theEvent;
@end

#endif // _URNOTIFICATIONHANDLER_H_
