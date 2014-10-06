//
//  ViewController.m
//  ScrollViewLayouting
//
//  Created by Alex Antonyuk on 10/6/14.
//  Copyright (c) 2014 Alex Antonyuk. All rights reserved.
//

#import "ViewController.h"
#import "ScrollViewLayoutingManager.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) ScrollViewLayoutingManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.manager = [[ScrollViewLayoutingManager alloc] initWithScrollView:self.scroller];
	
//	for (int i = 0; i < 10; ++i)
//	{
//		UIView *box = [UIView new];
//		box.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0
//											  green:arc4random_uniform(255)/255.0
//											   blue:arc4random_uniform(255)/255.0
//											  alpha:1.0];
//		NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
//		[box addConstraints:vc];
//		NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
//		[box addConstraints:hc];
//		[self.manager appendView:box];
//	}
	
	UIView *linkBox;
	NSLayoutConstraint *height;
	
	{
		UIView *box = [UIView new];
		box.backgroundColor = [UIColor redColor];
		NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:vc];
		NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:hc];
		[self.manager appendView:box];
//		linkBox = box;
	}
	
	{
		UIView *box = [UIView new];
		box.backgroundColor = [UIColor greenColor];
		NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:vc];
		height = vc.firstObject;
		NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:hc];
		[self.manager appendView:box];
		linkBox = box;
	}
	
	{
		UIView *box = [UIView new];
		box.backgroundColor = [UIColor yellowColor];
		NSArray *vc = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[box(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:vc];
		NSArray *hc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[box(320)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(box)];
		[box addConstraints:hc];
		[self.manager insertView:box afterView:linkBox];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		[self.manager removeView:linkBox animated:YES];
		height.constant = 200;
		[self.scroller updateConstraintsIfNeeded];
		[UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:.25 initialSpringVelocity:.5 options:0 animations:^{
			[self.scroller layoutIfNeeded];
		} completion:nil];
	});
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
