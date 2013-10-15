//
//  DSViewController.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-16.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DSViewController.h"
#import "DSCourseDetailViewController.h"
#import "DSShowInfoViewController.h"
#import "DSDataSource.h"
#import "DSMiddleScoreLabel.h"
#import "DSSettingsViewController.h"


#define __COURSE_VIEW_TAG(__WIDTH, __ROW, __COL)    ((__ROW) * (__WIDTH) + (__COL) + 100)
#define __ROW(__TAG, __WIDTH)                       (((__TAG) - 100) / (__WIDTH))
#define __COL(__TAG, __WIDTH)                       (((__TAG) - 100) % (__WIDTH))

#define COURSE_VIEW_TAG(__ROW, __COL)   __COURSE_VIEW_TAG(_maxCountOfCols, __ROW, __COL)
#define ROW(__TAG)                      __ROW(__TAG, _maxCountOfCols)
#define COL(__TAG)                      __COL(__TAG, _maxCountOfCols)

static NSString *kTheme1Image = @"6159252dd42a28343d864ac35ab5c9ea14cebfd1.jpg";

@interface DSViewController ()
{
    // Geometry
    CGRect      _appFrame;
    CGSize      _leftTopCornnerSize;
    CGSize      _statisticsLabelSize;
    CGRect      _scrollViewFrame;
    CGSize      _courseViewCellSize;
    CGFloat     _middleScoreBreadth;
    // others
    NSArray     *_colors;
    NSArray     *_weekDays;
}

- (void)setCourseView:(DSCourseDetails *)courseDetail;
@end

@implementation DSViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (id)init {
    self = [super init];
    if (self) {

        // Data
        DSDataSource *dataSource = [DSDataSource sharedDataSource];
        _maxCountOfCols = 7;
        _maxCountOfRows = 12;
        _numOfCols = dataSource.syllabusWidth;
        _numOfRows = dataSource.syllabusHeight;

        //      UI 
        // 蛋疼的横屏
        // 横屏模式的applicationFrame的width为高，height为宽
        // 后面不需再特殊处理
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        _appFrame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height, frame.size.width);
        _leftTopCornnerSize = CGSizeMake(40, 30);
        _statisticsLabelSize = CGSizeMake(80, 27);
        _middleScoreBreadth = 3.0f;

        _scrollViewFrame = _appFrame;
        _scrollViewFrame.size.height -= _statisticsLabelSize.height;

        _courseViewCellSize.width = (_scrollViewFrame.size.width - _leftTopCornnerSize.width) / (_numOfCols);
        _courseViewCellSize.height = (_scrollViewFrame.size.height - _leftTopCornnerSize.height) / (_numOfRows);

        _colors = @[[UIColor redColor],        // 1.0, 0.0, 0.0 RGB
                    [UIColor greenColor],      // 0.0, 1.0, 0.0 RGB
                    [UIColor blueColor],       // 0.0, 0.0, 1.0 RGB
                    [UIColor cyanColor],       // 0.0, 1.0, 1.0 RGB
                    [UIColor yellowColor],     // 1.0, 1.0, 0.0 RGB
                    [UIColor magentaColor],    // 1.0, 0.0, 1.0 RGB
                    [UIColor orangeColor],     // 1.0, 0.5, 0.0 RGB
                    [UIColor purpleColor]];    // 0.5, 0.0, 0.5 RGB
        
        _weekDays = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];

        // misc
        _editingCourse = nil;
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)loadView {
    self.navigationItem.title = @"Cute Syllabus";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearData:)];
#if 0
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, 65, 30);
    UIImage *btnBackImage = [self imageWithColor:[UIColor colorWithWhite:0.05f alpha:0.5f]];
    [settingButton setBackgroundImage:btnBackImage forState:UIControlStateNormal];
    settingButton.layer.cornerRadius = 8.0f;
    settingButton.clipsToBounds = YES;
    //    settingButton.viewForBaselineLayout.backgroundColor = [UIColor greenColor]; // useful
    [settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [settingButton addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
#endif
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Theme" style:UIBarButtonItemStyleDone target:self action:@selector(settings)];
    self.navigationItem.rightBarButtonItem.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];  // black translucent
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];

    self.view = [[UIView alloc]initWithFrame:_appFrame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // bottom view
//    self.bottomView
    self.statistisLabel = [UILabel new];
    self.statistisLabel.frame = CGRectMake(5, _scrollViewFrame.size.height, _statisticsLabelSize.width, _statisticsLabelSize.height);
    [self.view addSubview:self.statistisLabel];

    CGRect labelFrame = CGRectMake(_scrollViewFrame.size.width - 170, _scrollViewFrame.size.height + 7,
                                   30, _statisticsLabelSize.height);
    UILabel *slideLabel = [[UILabel alloc]initWithFrame:labelFrame];
    slideLabel.text = @"启用拖动复制";
    slideLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:slideLabel];
    [slideLabel sizeToFit];
    slideLabel.hidden = YES;

    labelFrame = slideLabel.frame;
    CGRect switchFrame = CGRectMake(labelFrame.origin.x + labelFrame.size.width + 5, _scrollViewFrame.size.height, 10, 10);
    UISwitch *dragCopySwitch = [[UISwitch alloc]initWithFrame:switchFrame];
    [dragCopySwitch addTarget:self action:@selector(shiftDragCopy:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dragCopySwitch];
    dragCopySwitch.hidden = YES;

    // scroll view
    self.scrollView = [[UIScrollView  alloc]initWithFrame:_scrollViewFrame];
    self.scrollView.contentSize = _appFrame.size;
    [self.view addSubview:self.scrollView];

    //
    [self loadScrollView];

    //  主题设置
    [self setTheme:[UIImage imageNamed:kTheme1Image]];
}

- (void)loadScrollView {

    self.syllabusView = [[UIView alloc]initWithFrame:_appFrame];
    self.syllabusView.autoresizesSubviews = YES;  // default
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = (CGRect){CGPointZero, _leftTopCornnerSize};
    infoButton.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.syllabusView addSubview:infoButton];

    CGFloat cvWidth    = _courseViewCellSize.width;
    CGFloat cvHeight   = _courseViewCellSize.height;
    CGFloat orginx[7]  = {0};
    CGFloat orginy[12] = {0};

    for (int j = 0; j < _maxCountOfRows; j++) {
        orginy[j] = _leftTopCornnerSize.height + cvHeight * j + _middleScoreBreadth * ((int)j / 4);
        // 课表左侧的序数
        UIButton *orderOfCourse = [[UIButton alloc]initWithFrame:CGRectMake(0, orginy[j], _leftTopCornnerSize.width, cvHeight)];
        orderOfCourse.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        orderOfCourse.titleLabel.font = [UIFont systemFontOfSize:13];
        orderOfCourse.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *string = [NSString stringWithFormat:@"%d", j + 1];
        [orderOfCourse setTitle:NSLocalizedString(string, nil) forState:UIControlStateDisabled];
        [orderOfCourse setTitleColor:[UIColor purpleColor] forState:UIControlStateDisabled];
        orderOfCourse.enabled = NO;
//        orderOfCourse.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        orderOfCourse.tag = 1000 + j * 2;

        [self.syllabusView addSubview:orderOfCourse];
    }

    for (int i = 0; i < _maxCountOfCols; i++) {
        orginx[i] = _leftTopCornnerSize.width + cvWidth * i + _middleScoreBreadth * ((int)i / 5);

        // 课表上侧的星期
        UIButton *weekDays = [[UIButton alloc]initWithFrame:CGRectMake(orginx[i], 0, cvWidth, _leftTopCornnerSize.height)];
        weekDays.enabled = NO;
        weekDays.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.5];
        [weekDays setTitle:NSLocalizedString(_weekDays[i], nil)  forState:UIControlStateDisabled];
        weekDays.titleLabel.font = [UIFont systemFontOfSize:13];
        [weekDays setTitleColor:[UIColor purpleColor] forState:UIControlStateDisabled];
        weekDays.titleLabel.textAlignment = NSTextAlignmentCenter;
//        weekDays.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        weekDays.tag = 1000 + i * 2 + 1;

        [self.syllabusView addSubview:weekDays];
    }

    self.syllabusView.frame = CGRectMake(0, 0, orginx[_maxCountOfCols - 1] + cvWidth, orginy[_maxCountOfRows - 1] + cvHeight);

    for (int i = 0; i < _maxCountOfRows; i++) {
        for (int j = 0; j < _maxCountOfCols; j++) {
            CGRect frame = CGRectMake(orginx[j], orginy[i], cvWidth, cvHeight);
            UIButton *courseView = [[UIButton alloc]initWithFrame:frame];

            courseView.tag = COURSE_VIEW_TAG(i, j);

            [courseView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            courseView.layer.borderColor = [UIColor grayColor].CGColor;
            courseView.layer.borderWidth = 0.3f;
            if ((i + j) % 2 == 0) {
//                courseView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
                courseView.layer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5].CGColor;
            } else {
                courseView.layer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.5].CGColor;
            }
            courseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            //            courseView.backgroundColor = _colors[arc4random() % 8];
            [courseView addTarget:self action:@selector(courseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.syllabusView addSubview:courseView];
        }
    }

    DSMiddleScoreLabel *middleScore[3] = {nil};

    CGRect frame = CGRectMake(0, orginy[4] - _middleScoreBreadth,
                              orginx[6] + cvWidth, _middleScoreBreadth);
    middleScore[0] = [[DSMiddleScoreLabel alloc]initWithFrame:(frame)
                                             scoreOrientation:DSMiddleScoreLabelOrientationHorizontal
                                                  lineBreadth:_middleScoreBreadth];
    frame.origin.y = orginy[8] - _middleScoreBreadth;
    middleScore[1] = [[DSMiddleScoreLabel alloc]initWithFrame:(frame)
                                             scoreOrientation:DSMiddleScoreLabelOrientationHorizontal
                                                  lineBreadth:_middleScoreBreadth];
    frame = CGRectMake(orginx[5] - _middleScoreBreadth, 0, _middleScoreBreadth, orginy[11] + cvHeight);
    middleScore[2] = [[DSMiddleScoreLabel alloc]initWithFrame:(frame)
                                             scoreOrientation:DSMiddleScoreLabelOrientationVertical
                                                  lineBreadth:_middleScoreBreadth];
    
    [self.syllabusView addSubview:middleScore[0]];
    [self.syllabusView addSubview:middleScore[1]];
    [self.syllabusView addSubview:middleScore[2]];

    [self.scrollView addSubview:self.syllabusView];

    self.scrollView.delegate = self;
    CGFloat minScale = _scrollViewFrame.size.width / self.syllabusView.frame.size.width;
    CGFloat minScale0 = _scrollViewFrame.size.height / self.syllabusView.frame.size.height;
    self.scrollView.minimumZoomScale = (minScale < minScale0) ? minScale : minScale0;
    self.scrollView.maximumZoomScale = 2.0;
    
    self.scrollView.contentSize = self.syllabusView.frame.size;
//    self.contentView.pagingEnabled = YES;
}


- (void)setTheme:(UIImage *)image {
    UIImageView *backgroud = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:backgroud];
    backgroud.frame = self.view.frame;
    backgroud.contentMode = UIViewContentModeScaleAspectFill;
    [self.view sendSubviewToBack:backgroud];

    self.statistisLabel.backgroundColor = [UIColor clearColor];
}

- (void)shiftDragCopy:(UISwitch *)sender {
    if (sender.on) {
//        self.contentView.scrollEnabled = NO;
//        self.contentView.userInteractionEnabled = NO;
//        self.scrollView.canCancelContentTouches = NO;
    } else {
//        self.scrollView.canCancelContentTouches = YES;
    }
}

- (void)clearData:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure to CLEAR all data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)showInfo {
    DSShowInfoViewController *infoVC = [DSShowInfoViewController new];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)settings {
    DSSettingsViewController *settingVC = [[DSSettingsViewController alloc]initWithNibName:@"DSSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)courseButtonClicked:(UIButton *)sender {
    DSCourseDetailViewController *cdvc = [[DSCourseDetailViewController alloc]initWithNibName:@"DSCourseDetailViewController" bundle:nil];
    
    int col = COL(sender.tag);
    int row = ROW(sender.tag);
    NSString *format = NSLocalizedString(@"ClassNo", nil);
    format = [@", " stringByAppendingString: format];
    // @"%@, 第%d节课"
    cdvc.navigationItem.title = [NSLocalizedString(_weekDays[col], nil) stringByAppendingFormat:format, row + 1];

    self.editingCourse = [[DSDataSource sharedDataSource] courseDetailsOfSyllabus:0 forRow:row andCol:col];
    if (self.editingCourse == nil) {
        self.editingCourse = [[DSCourseDetails alloc]initWithCourseName:@"" weekday:col ordinal:row time:@""];
    }
    cdvc.course = self.editingCourse;

//    cdvc.modalPresentationStyle = UIModalPresentationPageSheet;
//    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    // 动画
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [self.navigationController pushViewController:cdvc animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];

    UIResponder *res = sender.nextResponder;
    while (res) {
        MyLog(@"%@", res);
        res = res.nextResponder;
    }

    [self.navigationController pushViewController:cdvc animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];

    BOOL isHidden = self.navigationController.navigationBarHidden;

    [self.navigationController setNavigationBarHidden:(isHidden = !isHidden) animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self loadData];  // 重新加载数据
}

- (void)loadData {
    DSDataSource *ds = [DSDataSource sharedDataSource];
    
    //    for (DSCourseDetails *cd in ds.mySyllabus.allValues) {
    //        [self setCourseView:cd];
    //    }

    // 课程信息
    for (int i = 0; i < _maxCountOfRows; i++) {
        for (int j = 0; j < _maxCountOfCols; j++) {
            UIButton *courseView = (UIButton *)[self.syllabusView viewWithTag:COURSE_VIEW_TAG(i, j)];
            DSCourseDetails *cd = [ds courseDetailsOfSyllabus:0 forRow:i andCol:j];
            [courseView setTitle:cd.courseName forState:UIControlStateNormal];
        }
    }

    // 统计信息
    NSInteger count = [[DSDataSource sharedDataSource] coutOfMySyllabus];
    self.statistisLabel.text = [NSString stringWithFormat:NSLocalizedString(@"classesInfo", nil), count];
    CGSize labelSize = [self.statistisLabel.text sizeWithFont:self.statistisLabel.font];
    self.statistisLabel.bounds = (CGRect){CGPointZero, labelSize};
    self.statistisLabel.center = CGPointMake(CGRectGetMidX(_appFrame), CGRectGetMidY(self.statistisLabel.frame));
    
}

// unused right now
- (void)setCourseView:(DSCourseDetails *)courseDetail {
    if (courseDetail) {
        NSInteger row = courseDetail.courseOrdinal;  // 从0开始
        NSInteger col = courseDetail.courseWeekday;
        UIButton *courseView = (UIButton *)[self.syllabusView viewWithTag:COURSE_VIEW_TAG(row, col)];
        printf("%d, %d, %d\n", row, col, COURSE_VIEW_TAG(row, col));
        [courseView setTitle:courseDetail.courseName forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - Alert View Delegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [[DSDataSource sharedDataSource] clearData];
        [self loadData];
    }
}

#pragma mark - scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView     // return a view that will be scaled. if delegate returns nil, nothing happens
{
    return scrollView.subviews[0];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView   // return a yes if you want to scroll to the top. if not defined, assumes YES
{
    return NO;
}
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;      // called when scrolling animation finished. may be called immediately if already at top

@end
