//
//  DSCourseDetails.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-18.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSCourseDetails : NSObject<NSCoding>

@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, assign)NSInteger courseWeekday; // 星期%d的课，0～6，每周7天
@property (nonatomic, assign)NSInteger courseOrdinal; // 第%d节课，  0～7+ 每天默认8节课
@property (nonatomic, copy)NSString *courseTime;    // e.g. from 8:00 to 10:00

- (id)initWithCourseName:(NSString *)courseName weekday:(int)weekday ordinal:(int)ordinal time:(NSString *)time;

@end
