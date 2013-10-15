//
//  DSDataSource.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-9-23.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import "DSDataSource.h"
#import "DSCourseDetails.h"

static  NSString *const kIsFirstRunning       =  @"isFirstRunning";
static  NSString *const kMySyllabusWidthKey   =  @"myWidth";
static  NSString *const kMySyllabusHeightKey  =  @"myHeight";
static  NSString *const kHerSyllabusWidthKey  =  @"HerWidth";
static  NSString *const kHerSyllabusHeightKey =  @"HerHeight";
static  NSString *const kMySyllabusKey        =  @"MySyllabus";
static  NSString *const kHerSyllabusKey       =  @"HerSyllabus";


@interface DSDataSource ()
{
    NSInteger _mySyllabusWidth;
    NSInteger _mySyllabusHeight;

    NSInteger _herSyllabusWidth;
    NSInteger _herSyllabusHeight;

    NSInteger _syllabusWidth;
    NSInteger _syllabusHeight;

    NSInteger _syllabusMaxWidth;
    NSInteger _syllabusMaxHeight;

    NSInteger _syllabusDefaultWidth;
    NSInteger _syllabusDefaultHeight;
}

- (id)initSingleton;

@end

@implementation DSDataSource

@synthesize mySyllabusWidth = _mySyllabusWidth;
@synthesize mySyllabusHeight = _mySyllabusHeight;
@synthesize herSyllabusWidth = _herSyllabusWidth;
@synthesize herSyllabusHeight = _herSyllabusHeight;
@synthesize syllabusWidth = _syllabusWidth;
@synthesize syllabusHeight = _syllabusHeight;

+ (id)sharedDataSource {
    static DSDataSource *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initSingleton];
    });
    return instance;
}

- (id)init {
    NSAssert(NO, @"You can't init a instance.");
    
    return nil;
}

//- (void)dealloc {
//    [self saveToUserDefaults];
//}

- (id)initSingleton {
    if (self = [super init]) {
        _syllabusMaxWidth   = 7;    // 一周最多7天
        _syllabusMaxHeight  = 12;   // 每天至多12节课
        _syllabusDefaultWidth = 7;  // 默认一周上7天课
        _syllabusDefaultHeight = 12; // 默认每天上12节课

        NSUserDefaults *ud  = [NSUserDefaults standardUserDefaults];
        BOOL isFirstRunning = [ud boolForKey:kIsFirstRunning]; // 是否有旧数据
        if (!isFirstRunning) { // 
            [self initializeWithDefaultValues];
            NSLog(@"First run this app!");
        } else {  // 非首次运行
            // 读取user defaults
            _mySyllabusWidth   = [ud integerForKey:kMySyllabusWidthKey];
            _mySyllabusHeight  = [ud integerForKey:kMySyllabusHeightKey];
            _herSyllabusWidth  = [ud integerForKey:kHerSyllabusWidthKey];
            _herSyllabusHeight = [ud integerForKey:kHerSyllabusHeightKey];
            
            NSData *mySyllabusData   = [ud objectForKey:kMySyllabusKey];
            NSData *herSyllabusData  = [ud objectForKey:kHerSyllabusKey];
            _mySyllabus  = [[NSKeyedUnarchiver unarchiveObjectWithData:mySyllabusData] mutableCopy];
            _herSyllabus = [[NSKeyedUnarchiver unarchiveObjectWithData:herSyllabusData] mutableCopy];
            NSLog(@"App has run before!");
        }
    }
    return self;
}

- (void)initializeWithDefaultValues {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:kIsFirstRunning];
    
    _mySyllabusWidth = _herSyllabusWidth = _syllabusDefaultWidth;
    _mySyllabusHeight = _herSyllabusHeight = _syllabusDefaultHeight;

    _mySyllabus  = [[NSMutableDictionary alloc]initWithCapacity:0];
    _herSyllabus = [[NSMutableDictionary alloc]initWithCapacity:0];

    [self saveToUserDefaults];
}

- (void)saveToUserDefaults {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    [ud setInteger:_mySyllabusWidth forKey:kMySyllabusWidthKey];
    [ud setInteger:_mySyllabusHeight forKey:kMySyllabusHeightKey];
    [ud setInteger:_herSyllabusWidth forKey:kHerSyllabusWidthKey];
    [ud setInteger:_herSyllabusHeight forKey:kHerSyllabusHeightKey];
    
    NSData *mySyllabusData = [NSKeyedArchiver archivedDataWithRootObject:_mySyllabus];
    NSData *herSyllabusData = [NSKeyedArchiver archivedDataWithRootObject:_herSyllabus];
    [ud setObject:mySyllabusData forKey:kMySyllabusKey];
    [ud setObject:herSyllabusData forKey:kHerSyllabusKey];
    
    [ud synchronize];
}


- (void)clearData {
    // 清空
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:bundleIdentifier];

    [self initializeWithDefaultValues];
}

// col = 1..._mySyllabusWidth or _herSyllabusWidth
- (void)setCourseDetails:(DSCourseDetails *)cd ForSyllabus:(NSInteger)flag forRow:(NSInteger)row andCol:(NSInteger)col {
    NSString *key = nil;
    switch (flag) {
        case 0: {
            key = [NSString stringWithFormat:@"%d", (_syllabusMaxWidth * row + col)];
            if ([cd.courseName isEqualToString:@""]) {
                [self.mySyllabus removeObjectForKey:key];
            } else {
                [self.mySyllabus setObject:cd forKey:key];
            }
            break;
        }
        case 1: {
            key = [NSString stringWithFormat:@"%d", (_syllabusMaxWidth * row + col)];
            if ([cd.courseName isEqualToString:@""]) {
                [self.herSyllabus removeObjectForKey:key];
            } else {
                [self.herSyllabus setObject:cd forKey:key];
            }
            break;
        }

        default:
            NSAssert(NO, @"flag should be 0 or 1.");
            break;
    }
}

- (DSCourseDetails *)courseDetailsOfSyllabus:(NSInteger)flag forRow:(NSInteger)row andCol:(NSInteger)col {
    DSCourseDetails *cd = nil;
    NSString *key = nil;
    switch (flag) {
        case 0: {
            key = [NSString stringWithFormat:@"%d", (_syllabusMaxWidth * row + col)];
            cd = [self.mySyllabus objectForKey:key];
            break;
        }
        case 1: {
            key = [NSString stringWithFormat:@"%d", (_syllabusMaxWidth * row + col)];
            cd = [self.herSyllabus objectForKey:key];
            break;
        }

        default:
            NSAssert(NO, @"flag should be 0 or 1.");
            break;
    }
    
    return cd;
}


#pragma mark - syllabus common property
//           syllabusWidth
- (NSInteger)syllabusWidth {
    return (_mySyllabusWidth > _herSyllabusWidth) ? _mySyllabusWidth : _herSyllabusWidth;
}

- (NSInteger)syllabusHeight {
    return (_mySyllabusHeight > _herSyllabusHeight) ? _mySyllabusHeight : _herSyllabusHeight;
}


#pragma mark - my syllabus

// width
- (NSInteger)mySyllabusWidth {
    return _mySyllabusWidth;
}

- (void)setMySyllabusWidth:(NSInteger)width {
    if (width > 0) {
        _mySyllabusWidth = width;
    }
}

// height
- (NSInteger)mySyllabusHeight {
    return _mySyllabusHeight;
}

- (void)setMySyllabusHeight:(NSInteger)height {
    if (height > 0) {
        _mySyllabusHeight = height;
    }
}

// cout
- (NSUInteger)coutOfMySyllabus {
    return self.mySyllabus.count;
}

#pragma mark - her syllabus

// width
- (NSInteger)herSyllabusWidth {
    return _herSyllabusWidth;
}

- (void)setHerSyllabusWidth:(NSInteger)width {
    if (width > 0) {
        _herSyllabusWidth = width;
    }
}

// height
- (NSInteger)herSyllabusHeight {
    return _herSyllabusHeight;
}

- (void)setHerSyllabusHeight:(NSInteger)height {
    if (height > 0) {
        _herSyllabusHeight = height;
    }
}

// cout
- (NSUInteger)coutOfHerSyllabus {
    return self.herSyllabus.count;
}

@end
