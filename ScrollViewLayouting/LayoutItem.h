//
//  LayoutItem.h
//  ScrollViewLayouting
//
//  Created by Alex Antonyuk on 10/6/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

@import UIKit;

@interface LayoutItem : NSObject

@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

- (instancetype)initWithView:(UIView *)view topConstraint:(NSLayoutConstraint *)topConstraint;

@end
