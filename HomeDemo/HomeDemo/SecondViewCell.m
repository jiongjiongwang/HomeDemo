//
//  SecondViewCell.m
//  HomeDemo
//
//  Created by dn210 on 16/11/18.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "SecondViewCell.h"

@implementation SecondViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpUI];
        
    }
    return self;
}


-(void)setUpUI
{
    self.backgroundColor = [UIColor redColor];
}

@end
