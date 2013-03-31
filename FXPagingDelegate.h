//
//  FXPagingDelegate.h
//  FXPaging
//
//  Created by Saša Branković on 8.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXPagingView;

@protocol FXPagingDelegate<NSObject>
- (NSInteger)numberOfPagesInPagingView:(FXPagingView *)pagingView;
- (UIView *)pagingView:(FXPagingView *)pagingView viewForPage:(NSInteger)page;
- (void)pagingView:(FXPagingView *)pagingView didChangePage:(NSInteger)page;
- (void)pagingView:(FXPagingView *)pagingView didRemoveViewForPage:(NSInteger)page;
@end
