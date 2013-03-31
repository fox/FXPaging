//
//  FXPagingView.h
//  FXPaging
//
//  Created by Saša Branković on 10.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPagingDelegate.h"

@interface FXPagingView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, weak) id<FXPagingDelegate> pagingDelegate;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, readonly) NSInteger nextPage;
@property (nonatomic, readonly) NSInteger previousPage;
@property (nonatomic, getter = isEndless) BOOL endless;
@end
