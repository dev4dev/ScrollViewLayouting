//
//  ScrollViewLayoutingManager.m
//  ScrollViewLayouting
//
//  Created by Alex Antonyuk on 10/6/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "ScrollViewLayoutingManager.h"

// -----------------

@interface LayoutItem : NSObject

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

- (instancetype)initWithView:(UIView *)view topConstraint:(NSLayoutConstraint *)topConstraint;

@end

@implementation LayoutItem

- (instancetype)initWithView:(UIView *)view topConstraint:(NSLayoutConstraint *)topConstraint
{
	if (self = [super init]) {
		_view = view;
		_topConstraint = topConstraint;
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ - %@", self.view, self.topConstraint];
}

@end

// -----------------

@interface ScrollViewLayoutingManager ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@end

@implementation ScrollViewLayoutingManager

#pragma mark - Init & Dealloc

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
	if (self = [super init]) {
		_scrollView = scrollView;
		_views = [NSMutableArray array];
	}
	
	return self;
}


#pragma mark - Lifecycle (Setup/Update)


#pragma mark - Properties Getters


#pragma mark - Properties Setters


#pragma mark - Public Interface

- (void)appendView:(UIView *)view animated:(BOOL)animated
{
	[self insertView:view atIndex:self.views.count];
}

- (void)insertView:(UIView *)view atIndex:(NSUInteger)index animated:(BOOL)animated
{
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.scrollView addSubview:view];
	if (index < self.views.count) {
		LayoutItem *indexItem = self.views[index];
		if (index == 0) {
			// top item
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:vc];
			NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:hc];
			
			LayoutItem *item = [[LayoutItem alloc] initWithView:view topConstraint:vc.firstObject];
			[self.views insertObject:item atIndex:index];
		} else {
			// in middle
			LayoutItem *prevItem = self.views[index - 1];
			UIView *prevView = prevItem.view;
			
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(prevView, view)];
			[self.scrollView addConstraints:vc];
			NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:hc];
			
			LayoutItem *item = [[LayoutItem alloc] initWithView:view topConstraint:vc.firstObject];
			[self.views insertObject:item atIndex:index];
		}
		// insert before view
		
		[self.scrollView removeConstraint:indexItem.topConstraint];
		indexItem.topConstraint = nil;
		UIView *indexView = indexItem.view;
		NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view][indexView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, indexView)];
		[self.scrollView addConstraints:vc];
		
		
	} else {
		// insert as last view
		NSLog(@"last");
		if (self.bottomConstraint) {
			[self.scrollView removeConstraint:self.bottomConstraint];
			self.bottomConstraint = nil;
		}
		
		if (index == 0) {
			// to container
			NSLog(@"container");
			
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:vc];
			NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:hc];
			
			LayoutItem *item = [[LayoutItem alloc] initWithView:view topConstraint:vc.firstObject];
			[self.views insertObject:item atIndex:index];
		} else {
			// to prev view
			LayoutItem *prevItem = self.views[index - 1];
			
			UIView *prevView = prevItem.view;
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view, prevView)];
			[self.scrollView addConstraints:vc];
			NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
			[self.scrollView addConstraints:hc];
			
			LayoutItem *item = [[LayoutItem alloc] initWithView:view topConstraint:vc.firstObject];
			[self.views insertObject:item atIndex:index];

			NSLog(@"prev");
		}
		
		NSArray *bottomConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
		[self.scrollView addConstraints:bottomConstraint];
		self.bottomConstraint = bottomConstraint.firstObject;
	}
	if (animated) {
		[self.scrollView updateConstraintsIfNeeded];
		[UIView animateWithDuration:0.25 animations:^{
			[self.scrollView layoutIfNeeded];
		}];
	}
}

- (void)insertView:(UIView *)view afterView:(UIView *)afterView animated:(BOOL)animated
{
	NSUInteger index = [self indexOfView:afterView];
	[self insertView:view atIndex:index + 1 animated:animated];
}

- (void)insertView:(UIView *)view beforeView:(UIView *)beforeView animated:(BOOL)animated
{
	NSUInteger index = [self indexOfView:beforeView];
	[self insertView:view atIndex:index animated:animated];
}

- (NSUInteger)indexOfView:(UIView *)view
{
	return [self.views indexOfObjectPassingTest:^BOOL(LayoutItem *item, NSUInteger idx, BOOL *stop) {
		return [item.view isEqual:view];
	}];
}

- (void)appendView:(UIView *)view
{
	[self appendView:view animated:NO];
}

- (void)insertView:(UIView *)view atIndex:(NSUInteger)index
{
	[self insertView:view atIndex:index animated:NO];
}

- (void)insertView:(UIView *)view afterView:(UIView *)afterView
{
	[self insertView:view afterView:afterView animated:NO];
}

- (void)insertView:(UIView *)view beforeView:(UIView *)beforeView
{
	[self insertView:view beforeView:beforeView animated:NO];
}

- (void)removeView:(UIView *)view animated:(BOOL)animated
{
	NSUInteger index = [self indexOfView:view];
	[self removeViewAtIndex:index animated:animated];
}

- (void)removeViewAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	if (index < self.views.count) {
		LayoutItem *item = self.views[index];
		[item.view removeFromSuperview];
		if (index == 0) {
			// first
			LayoutItem *nextItem = self.views[index + 1];
			UIView *nextView = nextItem.view;
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nextView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(nextView)];
			[self.scrollView addConstraints:vc];
			nextItem.topConstraint = vc.firstObject;
		} else if (index == self.views.count - 1) {
			// last
			LayoutItem *prevItem = self.views[index - 1];
			UIView *prevView = prevItem.view;
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(prevView)];
			[self.scrollView addConstraints:vc];
			self.bottomConstraint = vc.firstObject;
		} else {
			// middle
			LayoutItem *prevItem = self.views[index - 1];
			UIView *prevView = prevItem.view;
			LayoutItem *nextItem = self.views[index + 1];
			UIView *nextView = nextItem.view;
			NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevView][nextView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(prevView, nextView)];
			[self.scrollView addConstraints:vc];
			nextItem.topConstraint = vc.firstObject;
		}
		[self.views removeObjectAtIndex:index];
		if (animated) {
			[self.scrollView updateConstraintsIfNeeded];
			[UIView animateWithDuration:0.25 animations:^{
				[self.scrollView layoutIfNeeded];
			}];
		}
	}
}

- (void)removeView:(UIView *)view
{
	[self removeView:view animated:NO];
}

- (void)removeViewAtIndex:(NSUInteger)index
{
	[self removeViewAtIndex:index animated:NO];
}


#pragma mark - Private methods



@end
