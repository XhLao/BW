//
//  BWButton.m
//  BW
//
//  Created by Xh.Lao on 2017/7/11.
//  Copyright © 2017年 Xh.Lao. All rights reserved.
//

#import "BWButton.h"

@implementation BWButton

- (void)changeColor {
    BOOL isWithe = [self.backgroundColor isEqual:[UIColor whiteColor]];
    self.backgroundColor = isWithe ? [UIColor blackColor] : [UIColor whiteColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
