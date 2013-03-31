//
//    AppDelegate.m
//    FXPagingDemo
//
//    Created by Saša Branković on 10.9.2012..
//    Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "AppDelegate.h"
#import "FXPagingView.h"

@implementation AppDelegate

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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    FXPagingView* pagingView = [[FXPagingView alloc] initWithFrame:self.window.frame];
    
    pagingView.pagingDelegate = self;
    pagingView.endless = NO;
    pagingView.page = 0;
    
    [self.window addSubview:pagingView];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark FXPagingDelegate methods

- (UIView *)pagingView:(FXPagingView *)pagingView viewForPage:(NSInteger)page
{
    NSLog(@"Loading page %d", page);
    
    NSArray *colorList = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor magentaColor],
                             [UIColor blueColor], [UIColor orangeColor], [UIColor brownColor], [UIColor grayColor], nil];
    
    UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
    view.backgroundColor = [colorList objectAtIndex:page % [colorList count]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.window.frame];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[NSString stringWithFormat:@"Page %d", page]];
    
    [view addSubview:label];
    
    return view;
}

- (void)pagingView:(FXPagingView *)pagingView didChangePage:(NSInteger)page
{
    NSLog(@"Page is now %d", page);
}

- (void)pagingView:(FXPagingView *)pagingView didRemoveViewForPage:(NSInteger)page
{
    NSLog(@"Removed view for page %d", page);
}

- (NSInteger)numberOfPagesInPagingView:(FXPagingView *)pagingView
{
    return 5;
}

@end
