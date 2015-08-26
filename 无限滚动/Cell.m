//
//  Cell.m
//  无限滚动
//
//  Created by MS on 15/8/26.
//  Copyright (c) 2015年 郑武. All rights reserved.
//

#import "Cell.h"
#import "CellModel.h"
@interface Cell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end


@implementation Cell

- (void)setModle:(CellModel *)modle
{
    _modle = modle;
    
    self.iconView.image = [UIImage imageNamed:modle.icon];
    
    self.titleLabel.text = [NSString stringWithFormat:@" %@",modle.title];
    
    
    



}
- (void)awakeFromNib {
    // Initialization code
}


@end
