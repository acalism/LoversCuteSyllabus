//
//  DSBubbleLabel.h
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-10-11.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DSBubbleLabel : UIView
{
    CGFloat _widthPadding;
    CGFloat _heightPadding;
}

@property (nonatomic, strong, readonly)UILabel *textLabel;

@property (nonatomic, strong)UIColor *backgroundColor;

@end
