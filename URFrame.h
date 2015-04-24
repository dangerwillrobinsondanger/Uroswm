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
}
-(id)initWithDisplay:(Display*)display;
/**
 * This method create a frame window, reparenting the window passed as argument
 */
-(void)createFrameForWindow:(URWindow*)window;

@end