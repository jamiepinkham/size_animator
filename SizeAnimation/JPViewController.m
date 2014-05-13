//
//  JPViewController.m
//  SizeAnimation
//
//  Created by Jamie Pinkham on 5/13/14.
//  Copyright (c) 2014 Jamie Pinkham. All rights reserved.
//


#define DO_INVALID_RECT 0

#import "JPViewController.h"

@interface JPViewController ()

@property (nonatomic, strong) UIView *anotherView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation JPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //add a view to mess around with
    
    self.anotherView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 200)];
    self.anotherView.backgroundColor = [UIColor greenColor];
    
    //put a label in it
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 20)];
    label.text = @"TEXT";
    label.backgroundColor = [UIColor redColor];
    [self.anotherView addSubview:label];
    
    //put a view behind the masked view to make sure we are actually clipping
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.anotherView.frame];
    imageView.image = [UIImage imageNamed:@"you_mad_camron.jpg"];
    
    [self.view addSubview:imageView];
    [self.view addSubview:self.anotherView];
    
    //a rect representing the full size of the rect we want to clip
    CGRect fullRect = CGRectMake(0, 0, CGRectGetWidth(self.anotherView.frame), CGRectGetHeight(self.anotherView.frame));
    
    //a rect representing the amount we want displaying after we clip (this has to be something valid or CA doesn't do shit) set DO_INVALID_RECT to 0 to see
#if DO_INVALID_RECT
    CGRect clippingRect = CGRectInset(fullRect, CGRectGetWidth(self.anotherView.frame), (CGRectGetHeight(self.anotherView.frame)));
#else
    CGRect clippingRect = CGRectInset(fullRect, CGRectGetWidth(self.anotherView.frame) / 2, CGRectGetHeight(self.anotherView.frame) / 2);
#endif
    //make a path with it
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:clippingRect];
    
    //make a mask layer set it's path and set it as the view we want to clip's mask
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = path.CGPath;
    self.anotherView.layer.mask = self.maskLayer;

    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //rect set up shit again
    CGRect fullRect = CGRectMake(0, 0, CGRectGetWidth(self.anotherView.frame), CGRectGetHeight(self.anotherView.frame));
#if DO_INVALID_RECT
    CGRect clippingRect = CGRectInset(fullRect, CGRectGetWidth(self.anotherView.frame), (CGRectGetHeight(self.anotherView.frame)));
#else
    CGRect clippingRect = CGRectInset(fullRect, CGRectGetWidth(self.anotherView.frame) / 2, CGRectGetHeight(self.anotherView.frame));
#endif
    
    //animate the layer's mask's path
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.toValue = (id)[UIBezierPath bezierPathWithRect:fullRect].CGPath;
    animation.fromValue = (id)[UIBezierPath bezierPathWithRect:clippingRect].CGPath;
    animation.duration = 1.3;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.maskLayer addAnimation:animation forKey:@"path"];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
