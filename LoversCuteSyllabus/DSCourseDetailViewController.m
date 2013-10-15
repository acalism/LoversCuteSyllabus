//
//  DSCourseDetailViewController.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-16.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import "DSCourseDetailViewController.h"
#import "DSViewController.h"
#import "DSDataSource.h"

@interface DSCourseDetailViewController ()

@end

@implementation DSCourseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.courseTextField.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmChanges:)];
    self.titleLabel.hidden = YES;

    [self.courseTextField becomeFirstResponder];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationItem.rightBarButtonItem.tintColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];

#if 0
    //      theme
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"6159252dd42a28343d864ac35ab5c9ea14cebfd1.jpg"]];
    [self.view addSubview:imageView];
    CGRect imageFrame = self.view.frame;
    CGFloat temp = imageFrame.size.width;
    imageFrame.size.width = imageFrame.size.height;
    imageFrame.size.height = temp;
    imageView.frame = imageFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view sendSubviewToBack:imageView];
#endif

    self.view.backgroundColor = [UIColor colorWithRed:0.7f green:0 blue:0.7f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
     self.courseTextField.text = self.course.courseName;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.courseTextField resignFirstResponder];
}

- (void)confirmChanges:(UIBarButtonItem *)sender {
    self.course.courseName = self.courseTextField.text;
    DSDataSource *ds = [DSDataSource sharedDataSource];
    [ds setCourseDetails:self.course ForSyllabus:0 forRow:self.course.courseOrdinal andCol:self.course.courseWeekday];

    [ds saveToUserDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
