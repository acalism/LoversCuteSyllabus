//
//  DSDataSource.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-23.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSCourseDetails.h"

@interface DSDataSource : NSObject 

@property (nonatomic, strong)NSMutableDictionary    *mySyllabus;
@property (nonatomic, assign)NSInteger              mySyllabusWidth;
@property (nonatomic, assign)NSInteger              mySyllabusHeight;

@property (nonatomic, strong)NSMutableDictionary    *herSyllabus;
@property (nonatomic, assign)NSInteger              herSyllabusWidth;
@property (nonatomic, assign)NSInteger              herSyllabusHeight;

@property (nonatomic, readonly, assign)NSInteger    syllabusWidth;
@property (nonatomic, readonly, assign)NSInteger    syllabusHeight;

@property (nonatomic, readonly, assign)NSUInteger    coutOfMySyllabus;
@property (nonatomic, readonly, assign)NSUInteger    coutOfHerSyllabus;



+ (id)sharedDataSource;
- (id)init;

- (void)saveToUserDefaults;

- (void)clearData;

- (DSCourseDetails *)courseDetailsOfSyllabus:(NSInteger)flag forRow:(NSInteger)row andCol:(NSInteger)col;
- (void)setCourseDetails:(DSCourseDetails *)cd ForSyllabus:(NSInteger)flag forRow:(NSInteger)row andCol:(NSInteger)col;

@end

