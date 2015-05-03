/*
   Project: uroswm

   Copyright (C) 2015 Alex Sangiuliano

   Author: Alex Sangiuliano

   Created: 2015-05-2 12:09:08 +0200 by Alex Sangiuliano

*/

/* This class implements the title bar */

#import <Foundation/Foundation.h>
#import "URFrame.h"

@interface URTitleBar : URFrame
{
    NSMutableString *title;
}

-(void)setTitle:(NSMutableString*)aTitle;
-(NSMutableString*) title;
-(void)createTitleBarForFrame:(URFrame*)aFrameWindow;
@end
