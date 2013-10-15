//
//  DSBubbleLabel.m
//  LoversCuteSyllabus
//
//  Created by Dawn Song on 13-10-11.
//  Copyright (c) 2013年 iscas. All rights reserved.
//

#import "DSBubbleLabel.h"

@implementation DSBubbleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;

        _textLabel = [UILabel new];
        [self addSubview:_textLabel];

        _widthPadding = frame.size.height / 2;
        _heightPadding = 0.0f;
        [self setLableFrameWithWidthPadding:_widthPadding HeightPadding:_heightPadding];
    }
    return self;
}


- (void)setLableFrameWithWidthPadding:(NSInteger)wPadding HeightPadding:(NSInteger)hPadding {
    CGRect labelFrame = self.frame;
    labelFrame.origin = CGPointZero;
    _textLabel.frame = CGRectInset(labelFrame, wPadding, hPadding);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    super.backgroundColor = backgroundColor;
    self.textLabel.backgroundColor = backgroundColor;
}


@end
