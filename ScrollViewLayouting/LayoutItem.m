//
//  LayoutItem.m
//  ScrollViewLayouting
//
//  Created by Alex Antonyuk on 10/6/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "LayoutItem.h"

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
