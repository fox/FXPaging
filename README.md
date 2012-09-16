<img src="http://dl.dropbox.com/u/5671499/github/fxpager.png" />

# FXPaging

FXPaging is an iOS libray for doing horizontal paging. All it needs is a `UIScrollView` and a delegate to handle page creation. It's fast and memory efficient, and should work seamlessly with any number of pages.

## Usage

Copy the source files from root directory into your project. For usage example, see the `FXPagingDemo` project.

Generally, you initialize the UIScrollView:

```objc
scrollView.pagingDelegate = delegate;
scrollView.page = 0;
``` 

then implement the delegate methods:

```objc
- (UIView *)scrollView:(UIScrollView *)scrollView viewForPage:(NSInteger)page {
	// returns view for a page 
}
- (NSInteger)numberOfPagesInScrollView:(UIScrollView *)scrollView {
    // returns number of pages
}
```

## Tips

* To enable endless scrolling, set `scrollView.endlessPaging = YES;` during setup.
* FXPaging keeps references to current and surrounding (previous / next) page views and releases them once they're no longer visible to the user. When that happens, delegates receive `scrollView:didRemoveViewForPage:` message where they can do additional cleanup (like remove reference to that view owner).
* Since views are kept only when needed, a subsequent calls to `scrollView:viewForPage:` could be made. Meaning if you'd like to persist views across pages, just make sure that method returns the same view instance for that particular page and don't do any cleanup in `scrollView:didRemoveViewForPage`. Beware of memory usage when dealing with large number of pages. 
* If you change number of pages after the initialization, call `scrollView.reloadPages` to make the change visible. 
* `scrollView.reloadPages` will also release and redraw the currently visible page so you might want to call that if you want to provide a different view for a current page.