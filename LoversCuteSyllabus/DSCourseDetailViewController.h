//
//  DSCourseDetailViewController.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-16.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSCourseDetails.h"

@interface DSCourseDetailViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UITextField *courseTextField;
@property (weak, nonatomic) IBOutlet UILabel *backgroundColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontColorLabel;

@property (weak, nonatomic) DSCourseDetails *course;

- (void)confirmChanges:(UIBarButtonItem *)sender;

@end
