@import AppKit;

#import "AppDelegate.h"

@implementation AppDelegate

// MARK: - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Setup listener for pongs
    NSString *pongName = @"com.nothingmagical.contrast.notification.pong";
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_pong:) name:pongName
                                                          object:nil];

    // Post ping
    NSString *pingName = @"com.nothingmagical.contrast.notification.ping";
    NSDistributedNotificationOptions options = NSDistributedNotificationDeliverImmediately;
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:pingName object:nil userInfo:nil options:options];
    NSLog(@"Ping…");

    // Defer launching in case we get a pong from an already running instance of Contrast.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _launchContrast];
    });
}

// MARK: - Private

- (void)_launchContrast {
    // Get application path
    NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
    pathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 4)];
    NSURL *url = [NSURL fileURLWithPath:[NSString pathWithComponents:pathComponents]];

    // Launch Contrast
    NSWorkspaceLaunchOptions options = NSWorkspaceLaunchWithoutActivation | NSWorkspaceLaunchAndHide;
    [[NSWorkspace sharedWorkspace] launchApplicationAtURL:url options:options configuration:@{} error:nil];
    NSLog(@"Launched Contrast at '%@'. Bye.", url.path);

    // Quit helper
    [NSApp terminate:nil];
}

- (void)_pong:(nullable NSNotification *)notification {
    // Contrast is running. Quit helper.
    NSLog(@"Received pong! Bye.");
    [NSApp terminate:nil];
}

@end
