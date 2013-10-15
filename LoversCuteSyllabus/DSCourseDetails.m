//
//  DSCourseDetails.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-18.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import "DSCourseDetails.h"

@implementation DSCourseDetails

- (id)initWithCourseName:(NSString *)courseName weekday:(int)weekday ordinal:(int)ordinal time:(NSString *)time {
    self = [super init];
    if (self) {
        _courseName     = courseName;
        _courseOrdinal  = ordinal;
        _courseTime     = time;
        _courseWeekday  = weekday;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //
    [aCoder encodeObject:_courseName forKey:@"courseName"];
    [aCoder encodeInteger:_courseOrdinal forKey:@"courseOrdinal"];
    [aCoder encodeObject:_courseTime forKey:@"courseTime"];
    [aCoder encodeInteger:_courseWeekday forKey:@"courseWeekday"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    //
    self = [super init];
    if (self) {
        _courseName = [aDecoder decodeObjectForKey:@"courseName"];
        _courseOrdinal = [aDecoder decodeIntegerForKey:@"courseOrdinal"];
        _courseTime = [aDecoder decodeObjectForKey:@"courseTime"];
        _courseWeekday = [aDecoder decodeIntegerForKey:@"courseWeekday"];
    }
    return self;
}

@end
