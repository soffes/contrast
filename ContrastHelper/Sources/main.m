@import AppKit;

#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    NSApplication.sharedApplication.delegate = appDelegate;
	return NSApplicationMain(argc, argv);
}
