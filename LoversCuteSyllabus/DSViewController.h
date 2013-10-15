//
//  DSViewController.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-16.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSCourseDetails.h"

@interface DSViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
{
    NSInteger   _numOfRows;
    NSInteger   _numOfCols;
    NSInteger   _maxCountOfCols;
    NSInteger   _maxCountOfRows;
}

@property (nonatomic, strong)UIScrollView       *scrollView;
@property (nonatomic, strong)UIView             *syllabusView;
@property (nonatomic, strong)UIView             *bottomView;
@property (nonatomic, strong)UILabel            *statistisLabel;
@property (nonatomic, strong)DSCourseDetails    *editingCourse;



@end
