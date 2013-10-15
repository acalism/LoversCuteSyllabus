//
//  DSSettingsViewController.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 10/12/13.
//  Copyright (c) 2013 iscas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DSSettingsViewController.h"

@interface DSSettingsViewController () {
    CGFloat _leftPadding, _topPadding;
}

@end

@implementation DSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftPadding = 30;
        _topPadding = 30;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kThemeImage]];
    self.view.backgroundColor = [UIColor purpleColor];
    
    CGRect frame = self.view.bounds;
    frame = CGRectInset(frame, _leftPadding, _topPadding);
    frame = CGRectOffset(frame, 0, 22);
    self.contentView = [[UIView alloc]initWithFrame:frame];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    [self.view addSubview:self.contentView];

    CGRect imageBounds =  CGRectMake(0, 0, frame.size.width / 3, frame.size.height / 3);
    CGFloat offsetX = frame.size.width / 2;
//    CGFloat offsetY = frame.size.height / 2;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectOffset(imageBounds, 30, 20)];
    imageView.image = [UIImage imageNamed:kThemeImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];

    imageView = [[UIImageView alloc]initWithFrame:CGRectOffset(imageBounds, offsetX+30, 20)];
    CGRect rect = imageView.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);  // fill
    CGContextFillRect(context, rect);   // fill

    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGFloat lineWidth = rect.size.height / 10;
    CGContextSetLineWidth(context, lineWidth);
    CGFloat wPadding = rect.size.width / 10;
    CGFloat hPadding = rect.size.height / 10;
    CGContextMoveToPoint(context, wPadding, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width - wPadding, rect.size.height / 2);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, rect.size.width / 2, hPadding);
    CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height - hPadding);
    CGContextStrokePath(context);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
