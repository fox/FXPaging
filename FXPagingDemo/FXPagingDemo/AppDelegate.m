//
//    AppDelegate.m
//    FXPagingDemo
//
//    Created by Saša Branković on 10.9.2012..
//    Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "AppDelegate.h"
#import "UIScrollView+FXPaging.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.window.frame];
    scrollView.pagingDelegate = self;
    scrollView.endlessPaging = NO;
    scrollView.page = 0;
    
    [self.window addSubview:scrollView];
    
    [scrollView release];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark FXPagingDelegate methods

- (UIView *)scrollView:(UIScrollView *)scrollView viewForPage:(int)page {
    NSLog(@"Loading page %d", page);
    
    NSArray *colorList = [[[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor magentaColor],
                             [UIColor blueColor], [UIColor orangeColor], [UIColor brownColor], [UIColor grayColor], nil] autorelease];
    
    UIView *pageView = [[[UIView alloc] initWithFrame:self.window.frame] autorelease];
    pageView.backgroundColor = [colorList objectAtIndex:page % [colorList count]];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:self.window.frame] autorelease];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"Page %d", page]];
    
    [pageView addSubview:label];
    
    return pageView;
}

- (void)scrollView:(UIScrollView *)scrollView didChangePage:(NSInteger)page {
    NSLog(@"Page is now %d", page);
}

- (void)scrollView:(UIScrollView *)scrollView didRemoveViewForPage:(NSInteger)page {
    NSLog(@"Removed view for page %d", page);
}

- (void) scrollView:(UIScrollView *)scrollView isHalfwayToPage:(NSInteger)page {
    NSLog(@"We're halfway to page %d", page);
}

- (int)numberOfPagesInScrollView:(UIScrollView *)scrollView {
    return 5;
}

@end
