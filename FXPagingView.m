//
//    FXPagingView.m
//    FXPaging
//
//    Created by Saša Branković on 8.9.2012..
//    Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "FXPagingView.h"

#define PAGE_TAG 100

@interface FXPagingView ()
@property (nonatomic, assign) char position;
@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL previousPageVisible;
- (void)addViewForPage:(int)page atPosition:(char)position;
@end

@implementation FXPagingView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _page = -1;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (void)setPagingDelegate:(id<FXPagingDelegate>)pagingDelegate
{
    _pagingDelegate = pagingDelegate;
    self.contentSize = CGSizeMake(self.frame.size.width * (self.numberOfPages > 1 ? 3 : 1), self.frame.size.height);
}

- (NSInteger)numberOfPages
{
    return [self.pagingDelegate numberOfPagesInPagingView:self];
}


- (NSInteger)previousPage {
  if (self.page == 0) {
    return [self isEndless] ? self.numberOfPages - 1 : -1;
  }
  return self.page - 1;
}

- (NSInteger)nextPage {
  if (self.page == self.numberOfPages - 1) {
    return [self isEndless] ? 0 : -1;
  }
  return self.page + 1;
}


- (void)setPosition:(char)position {
    _position = position;
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * position;
    frame.origin.y = 0;
    [self scrollRectToVisible:frame animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    double scrollPosition = self.contentOffset.x / self.frame.size.width;
    
    if (self.position == 1) {
        if (scrollPosition == 2.0) {
            self.page = self.nextPage; //         0   1 > 2
        } else if (scrollPosition == 0.0) {
            self.page = self.previousPage; //     0 < 1   2
        } else if (self.previousPageVisible == NO && self.previousPage == self.nextPage && scrollPosition < 1.0) {
            [self addViewForPage:self.previousPage atPosition:0];
            self.previousPageVisible = YES;
        }
        
    } else if (scrollPosition == 1.0) {
        if (self.position == 0) {
            self.page = self.nextPage; //         0 > 1   2
        } else if (self.position == 2) {
            self.page = self.previousPage; //     0   1 < 2
        }
    }
}

- (void)setPage:(NSInteger)page {
    if (!self.pagingDelegate) {
        [NSException raise:@"FXPagingDelegate not set" format:nil];
    }
    
    if (self.page == page) {
        return;
    }
    
    if (self.numberOfPages == 0) {
        return;
    }
    
    _page = page;
    
    for (UIView *view in [self subviews]) {
        NSInteger tag = view.tag - PAGE_TAG;
        if (tag != self.page && tag != self.previousPage && tag != self.nextPage) {
            [view removeFromSuperview];
            if ([self.pagingDelegate respondsToSelector:@selector(scrollView:didRemoveViewForPage:)]) {
                [self.pagingDelegate pagingView:self didRemoveViewForPage:tag];
            }
        }
    }
    
    if (self.page == 0 && self.previousPage == -1) {
        
        self.position = 0;
        
        [self addViewForPage:self.page atPosition:0];
        [self addViewForPage:self.nextPage atPosition:1];
        
    } else if (self.page == self.numberOfPages - 1 && self.nextPage == -1) {
        
        self.position = 2;
        
        [self addViewForPage:self.page atPosition:2];
        [self addViewForPage:self.previousPage atPosition:1];
    
    } else {
        
        self.position = 1;
        
        [self addViewForPage:self.page atPosition:1];
        [self addViewForPage:self.previousPage atPosition:0];
        [self addViewForPage:self.nextPage atPosition:2];
        
        if (self.previousPage == self.nextPage) {
            self.previousPageVisible = NO;
        }
    }
    
    if ([self.pagingDelegate respondsToSelector:@selector(pagingView:didChangePage:)]) {
        [self.pagingDelegate pagingView:self didChangePage:page];
    }
}

- (void)addViewForPage:(NSInteger)page atPosition:(char)position {
    if (page == -1) {
        return;
    }
    
    int tag = page + PAGE_TAG;
    UIView *view = [self viewWithTag:tag];
    if (!view) {
        view = [self.pagingDelegate pagingView:self viewForPage:page];
        view.tag = tag;
        [self addSubview:view];
    }
    
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * position;
    frame.origin.y = 0;
    view.frame = frame;
}
@end
