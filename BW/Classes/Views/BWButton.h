//
//  BWButton.h
//  BW
//
//  Created by Xh.Lao on 2017/7/11.
//  Copyright © 2017年 Xh.Lao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWButton : UIButton

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

- (void)changeColor;

@end
