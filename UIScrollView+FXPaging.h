//
//  UIScrollView+FXPaging.h
//  FXPaging
//
//  Created by Saša Branković on 10.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPagingDelegate.h"

@interface UIScrollView (FXPaging) <UIScrollViewDelegate>
@property (strong, nonatomic) id<FXPagingDelegate> pagingDelegate;
@property (nonatomic) int page;
@end
