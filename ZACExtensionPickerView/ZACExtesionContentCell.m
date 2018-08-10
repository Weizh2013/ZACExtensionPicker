//
//  KGOExteisonContentTableViewCell.m
//  KingoPalm
//
//  Created by Kingo on 2018/7/31.
//  Copyright © 2018年 Kingo. All rights reserved.
//

#import "ZACExtesionContentCell.h"

@implementation ZACExtesionContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
