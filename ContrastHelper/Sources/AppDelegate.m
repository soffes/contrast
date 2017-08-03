//
//  AppDelegate.m
//  ContrastHelper
//
//  Created by Sam Soffes on 8/3/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Get application path
	NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
	pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
	NSString *path = [NSString pathWithComponents:pathComponents];

	// Launch application
	[[NSWorkspace sharedWorkspace] launchApplication:path];

	// Quit helper
	[NSApp terminate:nil];
}

@end
