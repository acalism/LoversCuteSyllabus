//
//  DSMiddleScoreLabel.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-10-9.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DSMiddleScoreLabelOrientation) {
    DSMiddleScoreLabelOrientationHorizontal = 0,
    DSMiddleScoreLabelOrientationVertical
};

@interface DSMiddleScoreLabel : UILabel

@property (nonatomic, assign)CGFloat lineBreadth;
@property (nonatomic, assign)DSMiddleScoreLabelOrientation orientation;

- (id)initWithFrame:(CGRect)frame scoreOrientation:(DSMiddleScoreLabelOrientation)orientation lineBreadth:(CGFloat)breadth;
- (id)initWithFrame:(CGRect)frame;
- (id)init;

@end
