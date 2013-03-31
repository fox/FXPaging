<img src="http://dl.dropbox.com/u/5671499/github/fxpager.png" />

# FXPaging

FXPaging is an iOS libray for doing horizontal paging. All it needs is a `FXPagingView` and a delegate to handle page creation. It's fast and memory efficient, and should work seamlessly with any number of pages.

## Usage

Copy the source files from root directory into your project. For usage example, see the `FXPagingDemo` project.

Generally, you initialize the FXPagingView:

```objc
pagingView.pagingDelegate = delegate;
pagingView.page = 0;
``` 

then implement the delegate methods:

```objc
- (UIView *)pagingView:(FXPagingView *)pagingView viewForPage:(NSInteger)page {
	// returns view for a page 
}
- (NSInteger)numberOfPagesInPagingView:(FXPagingView *)pagingView {
    // returns number of pages
}
```

## Tips

* To enable endless scrolling, set `pagingView.endlessPaging = YES;` during setup.
* FXPaging keeps references to current and surrounding (previous / next) page views and releases them once they are no longer visible to the user. When that happens, delegates receive `pagingView:didRemoveViewForPage:` message so they can do additional cleanup (like remove reference to that view owner).
* Since views are kept only when needed, a subsequent calls to `pagingView:viewForPage:` could be made. If you'd like to persist views across pages, make sure that method returns the same view instance for the particular page, and don't do any cleanup in `pagingView:didRemoveViewForPage`. Beware of memory usage when dealing with large number of pages. 
* If you change number of pages after the initialization, call `pagingView.reloadPages` to make the change visible. 
* `pagingView.reloadPages` will also release and redraw the currently visible page so you might want to call that if you want to provide a different view for a current page.