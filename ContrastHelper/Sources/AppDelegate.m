@import AppKit;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@end

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
