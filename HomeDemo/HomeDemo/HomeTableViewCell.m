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

//1-图片
@property (nonatomic,weak)UIImageView *cellImage;

//2-标签
@property (nonatomic,weak)UILabel *cellLabel;


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
    
    
    //2-label
    UILabel *cellLabel = [[UILabel alloc] init];
    
    self.cellLabel = cellLabel;
    
    [cellLabel setTextAlignment:NSTextAlignmentCenter];
    
    [cellLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self.contentView addSubview:cellLabel];
    
    [cellLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView.mas_centerY);
        
        make.leading.equalTo(cellImage.mas_trailing).offset(20);
        
    }];
    
}

-(void)setLabelStr:(NSString *)labelStr
{
    _labelStr = labelStr;
    
    self.cellLabel.text = labelStr;
}


@end
