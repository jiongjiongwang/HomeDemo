//
//  HomeTableViewCell.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Masonry.h"

@interface HomeTableViewCell()



@end


@implementation HomeTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI
{
    //1-图片
    UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game replay"]];
    
    [self.contentView addSubview:cellImage];
    
    [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.contentView).offset(30);
        
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    
}


@end
