//
//  UIScrollView+FXPaging.m
//  FXPaging
//
//  Created by Saša Branković on 8.9.2012..
//  Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "UIScrollView+FXPaging.h"
#import "FXPagingDelegate.h"

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
int _numberOfPages;
BOOL _pagingInitialized = NO;
BOOL _nextPageVisible = NO;

- (id<FXPagingDelegate>)pagingDelegate {
  return _pagingDelegate;
}

- (void)setPagingDelegate:(id<FXPagingDelegate>)d {
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;
  self.delegate = self;
  _pagingDelegate = d;
  _pagingInitialized = NO;
  _page = -1;
  _nextPageVisible = NO;
}

-(void)reloadData {
  _pagingInitialized = NO;
  _page = -1;
  _nextPageVisible = NO;
  for (UIView *view in [self subviews]) {
    [view removeFromSuperview];
  }
  
  [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  if (_pagingInitialized == NO) {
    return;
  }
  
  double fractpart, intpart;
  fractpart = modf(self.contentOffset.x / self.frame.size.width, &intpart);
  
  if (intpart != 1.0) {
    if (fractpart < 0.1) {
      intpart < 1.0 ? (self.page = _prevPage) : (self.page = _nextPage);
    }
  } else if (_numberOfPages == 2) {
    if (fractpart > 0.01 && _nextPageVisible == NO) {
      [self loadPage:_nextPage atPosition:2];
      _nextPageVisible = YES;
    }
  }
}

- (int)page {
  return _page;
}

- (void)setPage:(int)page {
  if (page == _page) {
    return;
  }
  
  if (_pagingInitialized == NO) {
    _numberOfPages = [_pagingDelegate numberOfPagesInScrollView:self];
    
    if (_numberOfPages > 1) {
      self.pagingEnabled = YES;
      self.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    } else {
      self.pagingEnabled = NO;
    }
    _pagingInitialized = YES;
  }
  
  if (_numberOfPages == 0) {
    return;
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
  
  if (_numberOfPages == 1) {
    [self loadPage:_page atPosition:0];
  
  } else if (_numberOfPages == 2) {
    [self loadPage:_prevPage atPosition:0];
    [self loadPage:page atPosition:1];
    _nextPageVisible = NO;
  
  } else {
    [self loadPage:_prevPage atPosition:0];
    [self loadPage:_nextPage atPosition:2];
    [self loadPage:_page atPosition:1];
  }
  
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

@end
