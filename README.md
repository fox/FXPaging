<img src="http://dl.dropbox.com/u/5671499/github/fxpager.png" />

# FXPaging

FXPaging is an iOS libray for doing horizontal paging. All it needs is a `UISCrollView` and a delegate to handle page creation. It's fast and memory efficient, and should work seamlessly with any number of pages.

## Usage

Copy the source files from root directory into your project. For usage example, check the `FXPagingDemo` project.

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