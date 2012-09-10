//
//  FXPagingDelegate.h
//  FXPaging
//
//  Created by Saša Branković on 8.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FXPagingDelegate<NSObject>
@required
- (int) numberOfPagesInScrollView:(UIScrollView *) scrollView;
- (UIView *) scrollView:(UIScrollView *) scrollView viewForPage:(int)page;
@optional
- (void) scrollView:(UIScrollView *)scrollView pageDidChange:(int)page;
- (void) scrollView:(UIScrollView *)scrollView pageDidUnload:(int)page;
@end
