//
//  ScrollViewLayoutingManager.h
//  ScrollViewLayouting
//
//  Created by Alex Antonyuk on 10/6/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

@import UIKit;

@interface ScrollViewLayoutingManager : NSObject

@property (nonatomic, strong, readonly) NSArray *subviews;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)appendView:(UIView *)view;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)index;
- (void)insertView:(UIView *)view afterView:(UIView *)afterView;
- (void)insertView:(UIView *)view beforeView:(UIView *)beforeView;

- (void)appendView:(UIView *)view animated:(BOOL)animated;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)insertView:(UIView *)view afterView:(UIView *)afterView animated:(BOOL)animated;
- (void)insertView:(UIView *)view beforeView:(UIView *)beforeView animated:(BOOL)animated;
- (NSUInteger)indexOfView:(UIView *)view;

- (void)removeView:(UIView *)view;
- (void)removeViewAtIndex:(NSUInteger)index;

- (void)removeView:(UIView *)view animated:(BOOL)animated;
- (void)removeViewAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeAllViews;

@end
