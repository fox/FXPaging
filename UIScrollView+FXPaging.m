//
//    UIScrollView+FXPaging.m
//    FXPaging
//
//    Created by Saša Branković on 8.9.2012..
//    Copyright (c) 2012. Saša Branković. All rights reserved.
//

#import "UIScrollView+FXPaging.h"
#import "FXPagingDelegate.h"
#import <objc/runtime.h>

#define PAGE_TAG 100

@interface FXPagingState : NSObject
@property (nonatomic) NSInteger page;
@property (nonatomic) char position;
@property (nonatomic) BOOL endlessPaging;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) BOOL previousPageVisible;
@property (strong, nonatomic) id<FXPagingDelegate> pagingDelegate;
@property (nonatomic) BOOL initialized;
@end

@implementation FXPagingState
@synthesize page;
@synthesize position;
@synthesize endlessPaging;
@synthesize numberOfPages;
@synthesize previousPageVisible;
@synthesize pagingDelegate;
@synthesize initialized;

- (id)init {
    self = [super init];
    if (self) {
        self.numberOfPages = -1;
        self.page = -1;
    }
    return self;
}

- (void)dealloc {
    self.pagingDelegate = nil;
    [super dealloc];
}
@end

@interface UIScrollView (PrivateMethods)
- (void)addViewForPage:(int)page atPosition:(int)position;
- (FXPagingState *) pagingState;
@property (nonatomic, readonly) NSInteger nextPage;
@property (nonatomic, readonly) NSInteger previousPage;
@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic) char position;
@property (nonatomic) BOOL initialized;
@end

static char pagingStateKey;

@implementation UIScrollView (FXPaging)

- (FXPagingState *)pagingState {
    FXPagingState *state = (FXPagingState *)objc_getAssociatedObject(self, &pagingStateKey);
    if (!state) {
        state = [[[FXPagingState alloc] init] autorelease];
        self.pagingState = state;
    }
    return state;
}

- (NSInteger) numberOfPages {
    if (self.pagingState.numberOfPages == -1) {
        self.pagingState.numberOfPages = [self.pagingDelegate numberOfPagesInScrollView:self];
    }
    return self.pagingState.numberOfPages;
}

- (void) setPagingState:(FXPagingState *)pagingState {
    objc_setAssociatedObject(self, &pagingStateKey, pagingState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPagingDelegate:(id<FXPagingDelegate>)delegate {
    self.pagingState.pagingDelegate = delegate;
}

- (id<FXPagingDelegate>) pagingDelegate {
    return self.pagingState.pagingDelegate;
}

- (BOOL)initialized {
    return self.pagingState.initialized;
}

- (void)setInitialized:(BOOL)initialized {
    if (self.initialized == initialized) {
        return;
    }

    if (initialized == NO) {
        self.pagingEnabled = NO;
        self.delegate = nil;
        self.pagingState.page = -1;
        self.pagingState.numberOfPages = -1;
    } else {
        for (UIView *view in [self subviews]) {
            NSInteger tag = view.tag - PAGE_TAG;
            if (tag >= 0) {
                [view removeFromSuperview];
                if ([self.pagingDelegate respondsToSelector:@selector(scrollView:didRemoveViewForPage:)]) {
                    [self.pagingDelegate scrollView:self didRemoveViewForPage:tag];
                }
            }
        }
        self.contentSize = CGSizeMake(self.frame.size.width * (self.numberOfPages > 1 ? 3 : 1), self.frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = self.numberOfPages > 1;
        self.delegate = self.numberOfPages > 1 ? self : nil;
    }
 
    self.pagingState.initialized = initialized;
}

- (void)setEndlessPaging:(BOOL)endlessPaging {
    self.pagingState.endlessPaging = endlessPaging;
}

- (BOOL)endlessPaging {
    return self.pagingState.endlessPaging;
}

- (NSInteger)previousPage {
    if (self.page == 0) {
        return self.endlessPaging ? self.numberOfPages - 1 : -1;
    }
    return self.page - 1;
}

- (NSInteger)nextPage {
    if (self.page == self.numberOfPages - 1) {
        return self.endlessPaging ? 0 : -1;
    }
    return self.page + 1;
}

- (char)position {
    return self.pagingState.position;
}

- (void)setPosition:(char)position {
    self.pagingState.position = position;
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * position;
    frame.origin.y = 0;
    [self scrollRectToVisible:frame animated:NO];
}

- (int) page {
    return self.pagingState.page;
}

- (void)reloadPages {
    NSInteger page = self.page;
    self.initialized = NO;
    if (page < self.numberOfPages) {
        self.page = page;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    double scrollPosition = self.contentOffset.x / self.frame.size.width;
    
    if (self.position == 1) {
        if (scrollPosition == 2.0) {
            self.page = self.nextPage; //         0   1 > 2
        } else if (scrollPosition == 0.0) {
            self.page = self.previousPage; //     0 < 1   2
            
        } else if (self.pagingState.previousPageVisible == NO && self.previousPage == self.nextPage && scrollPosition < 1.0) {
            [self addViewForPage:self.previousPage atPosition:0];
            self.pagingState.previousPageVisible = YES;
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
    if (self.page == page) {
        return;
    }
    
    if (!self.initialized) {
        self.initialized = YES;
    }
    
    if (self.numberOfPages == 0) {
        return;
    }
    
    self.pagingState.page = page;
    
    for (UIView *view in [self subviews]) {
        NSInteger tag = view.tag - PAGE_TAG;
        if (tag != self.page && tag != self.previousPage && tag != self.nextPage) {
            [view removeFromSuperview];
            if ([self.pagingDelegate respondsToSelector:@selector(scrollView:didRemoveViewForPage:)]) {
                [self.pagingDelegate scrollView:self didRemoveViewForPage:tag];
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
            self.pagingState.previousPageVisible = NO;
        }
    }
    
    if ([self.pagingDelegate respondsToSelector:@selector(scrollView:didChangePage:)]) {
        [self.pagingDelegate scrollView:self didChangePage:self.page];
    }
}

- (void)addViewForPage:(NSInteger)page atPosition:(char)position {
    if (page == -1) {
        return;
    }
    
    int tag =    page + PAGE_TAG;
    UIView *view = [self viewWithTag:tag];
    if (!view) {
        view = [self.pagingDelegate scrollView:self viewForPage:page];
        view.tag = tag;
        [self addSubview:view];
    }
    
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * position;
    frame.origin.y = 0;
    view.frame = frame;
}
@end
