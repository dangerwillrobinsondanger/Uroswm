/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-24 17:08:08 +0200 by Alex Sangiuliano

*/

/**
  * This class implements a frame window
 */

#import <Foundation/Foundation.h>
#import "URWindow.h"

#include <X11/Xlib.h>

@interface URFrame : URWindow
{
    //(Window) children of the frame window
    NSMutableDictionary *children;
}
-(id)initWithDisplay:(Display*)display;
/**
 * This method create a frame window, reparenting the window passed as argument
 */
-(void)createFrameForWindow:(URWindow*)window;
/**
 * This method reparents the children to the frame. The argument can't be 0
 * The x and y arguments are the coordinates where the window will be placed
 * inside the frame.
 */
-(void)reparentChildWindow:(URWindow*)win atX:(int)x andY:(int)y;
/*
 * Returns the children dictionary
 */
-(NSDictionary*)children;
@end