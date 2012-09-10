//
//  UIScrollView+FXPaging.m
//  FXPaging
//
//  Created by Saša Branković on 8.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "UIScrollView+FXPaging.h"
#import "FXPagingDelegate.h"

#ifdef __has_feature
#define NO_ARC !__has_feature(objc_arc)
#else
#define NO_ARC 1
#endif

@interface UIScrollView (PrivateMethods)
- (void)loadPage:(int)page;
- (void)unloadPage:(int)page;
@end

@implementation UIScrollView (Paging)

#define PAGE_TAG 100

id<FXPagingDelegate> _pagingDelegate;
int _page = -1;
int _prevPage;
int _nextPage;
int _numberOfPages = -1;

- (id<FXPagingDelegate>)pagingDelegate {
    return _pagingDelegate;
}

- (void)setPagingDelegate:(id<FXPagingDelegate>)delegate {
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    _pagingDelegate = delegate;
#if NO_ARC
    [_pagingDelegate retain];
#endif

    self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
}

-(void)reloadData {
    _numberOfPages = [_pagingDelegate numberOfPagesInScrollView:self];
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    double fractpart, intpart;
    
    fractpart = modf(self.contentOffset.x / self.frame.size.width, &intpart);
    if (intpart != 1.0 && fractpart < 0.07) {
        intpart < 1.0 ? (self.page = _prevPage) : (self.page = _nextPage);
    }
}


- (int)page {
    return _page;
}

- (void)setPage:(int)page {
    if (page == _page) {
        return;
    }
    
    if (_numberOfPages == -1) {
        _numberOfPages = [_pagingDelegate numberOfPagesInScrollView:self];
    }
    
    _page = page;
    _prevPage = _page - 1 < 0 ? _numberOfPages - 1 : _page - 1;
    _nextPage = _page + 1 == _numberOfPages ? 0 : _page + 1;
    
    for (UIView *view in [self subviews]) {
        int tag = view.tag - PAGE_TAG;
        if (tag != _page && tag != _prevPage && tag != _nextPage) {
            [view removeFromSuperview];
            if ([_pagingDelegate respondsToSelector:@selector(scrollView:pageDidUnload:)]) {
                [_pagingDelegate scrollView:self pageDidUnload:tag];
            }
        }
    }
    
    [self loadPage:_prevPage atPosition:0];
    [self loadPage:_nextPage atPosition:2];
    [self loadPage:_page atPosition:1];
    
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    [self scrollRectToVisible:frame animated:NO];
    
    if ([_pagingDelegate respondsToSelector:@selector(scrollView:pageDidChange:)]) {
        [_pagingDelegate scrollView:self pageDidChange:page];
    }
}

- (void)loadPage:(int)page atPosition:(int)position {
    int tag =  page + PAGE_TAG;
    UIView *view = [self viewWithTag:tag];
    if (!view) {
        view = [_pagingDelegate scrollView:self viewForPage:page];
        view.tag = tag;
        [self addSubview:view];
    }
    
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * position;
    frame.origin.y = 0;
    view.frame = frame;
}

#if EGO_NO_ARC
-(void) dealloc {
    [_pagingDelegate release];
    [super dealloc];
}
#endif
@end
