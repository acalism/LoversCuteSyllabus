//
//  DSMiddleScoreLabel.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-10-9.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DSMiddleScoreLabel.h"


@implementation DSMiddleScoreLabel

- (id)initWithFrame:(CGRect)frame scoreOrientation:(DSMiddleScoreLabelOrientation)orientation lineBreadth:(CGFloat)breadth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _orientation = orientation;
        _lineBreadth = breadth;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame scoreOrientation:DSMiddleScoreLabelOrientationHorizontal lineBreadth:2.0f];
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //
}
*/

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextSetLineWidth(context, _lineBreadth);
//    CGContextMoveToPoint(context, 0, 0);
    CGFloat y = rect.origin.y / 2;
    CGPoint points[2] = {{0, y}, {self.bounds.size.width, y}};
    if (self.orientation == DSMiddleScoreLabelOrientationVertical) {
        CGFloat x = rect.origin.x / 2;
        points[0] = CGPointMake(x, 0);
        points[1] = CGPointMake(x, self.bounds.size.height);
    }
    CGContextAddLines(context, points, 2);
    CGContextStrokePath(context);

    [super drawTextInRect:rect];
}

@end
