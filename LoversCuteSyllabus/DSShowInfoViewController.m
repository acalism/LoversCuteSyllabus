//
//  DSShowInfoControllerViewController.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-10-11.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DSShowInfoViewController.h"
#import "DSBubbleLabel.h"

@interface DSShowInfoViewController () {
    CGFloat topMargin;
    CGFloat leftMargin;
}
@end

@implementation DSShowInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        topMargin = 50.0f;
        leftMargin = 20.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    CGRect frame = CGRectMake(leftMargin, topMargin, 300, 30);
    DSBubbleLabel *bubble[3] = {nil};
    bubble[0] = [[DSBubbleLabel alloc]initWithFrame:frame];
    bubble[1] = [[DSBubbleLabel alloc]initWithFrame:CGRectOffset(frame, 0, 50)];
    bubble[2] = [[DSBubbleLabel alloc]initWithFrame:CGRectOffset(frame, 0, 100)];
    bubble[0].backgroundColor = [UIColor colorWithRed:0.8f green:0.5f blue:0.2f alpha:0.8f];
    bubble[0].textLabel.text = @"1. 双指滑动来滚动屏幕；";
    bubble[1].backgroundColor = [UIColor colorWithRed:0.8f green:0.5f blue:0.2f alpha:0.8f];
    bubble[1].textLabel.text = @"2. 双指捏合缩放屏幕；";
    bubble[2].backgroundColor = [UIColor colorWithRed:0.8f green:0.5f blue:0.2f alpha:0.8f];
    bubble[2].textLabel.text = @"3. 点击底部显示更多功能；";
    for (int i = 0; i < 3; i++) {
        [self.view addSubview:bubble[i]];
    }

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"6159252dd42a28343d864ac35ab5c9ea14cebfd1.jpg"]];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"6159252dd42a28343d864ac35ab5c9ea14cebfd1.jpg"]];
    [self.view addSubview:imageView];
    CGRect imageFrame = self.view.frame;
    CGFloat temp = imageFrame.size.width;
    imageFrame.size.width = imageFrame.size.height;
    imageFrame.size.height = temp;
    imageView.frame = imageFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view sendSubviewToBack:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
