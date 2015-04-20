/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-04-12 10:21:47 +0200 by Alex Sangiuliano

*/

#import "UrosWindowManager.h"

#include <xcb/xproto.h>

@implementation UrosWindowManager

- (id) init
{
    self = [super init];
    
    if (self == nil)
    {
        return nil;
    }

    
    return self;
}

-(void) RunLoop
{
    if (theConnection == nil)
    {
        return;
    }

    [self checkOthersWM];
    NSLog(@"Uroswm: Connected");
}

-(void) checkOthersWM
{
    xcb_generic_error_t *error;
    XCBWindow *rootWindow = [[[theConnection screens] objectAtIndex:0] rootWindow];
    
    //NSLog(@"The rootWindow %@", rootWindow);
    uint32_t mask = XCB_CW_EVENT_MASK;
    uint32_t values[2];
    values[0] = XCB_EVENT_MASK_SUBSTRUCTURE_REDIRECT;
    xcb_void_cookie_t cookie = xcb_change_window_attributes_checked([theConnection connection], [rootWindow xcbWindowId], mask, values);
    error = xcb_request_check([theConnection connection], cookie);
    
    if (error != NULL && error->error_code == XCB_ACCESS)
    {
        NSLog(@"Uroswm: Another window manager is running!");
        free(error);
        exit(EXIT_FAILURE);
    }
//check if the code below is correct, for now it works
    //values[0] = 1;CHECK ON THE MANUAL: it should be done in this way, but I don't get the expected beahvior
    values[0] = XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY | XCB_EVENT_MASK_KEY_PRESS;
    xcb_change_window_attributes_checked([theConnection connection], [rootWindow xcbWindowId], mask, values);
}
@end
