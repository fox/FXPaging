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
- (NSInteger) numberOfPagesInScrollView:(UIScrollView *) scrollView;
- (UIView *) scrollView:(UIScrollView *) scrollView viewForPage:(NSInteger)page;
@optional
- (void) scrollView:(UIScrollView *)scrollView didRemoveViewForPage:(NSInteger)page;
- (void) scrollView:(UIScrollView *)scrollView didChangePage:(NSInteger)page;
@end
