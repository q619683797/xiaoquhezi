//
//  SummerRepairListsHeaderTableViewCell.m
//  WeCommunity
//
//  Created by madarax on 15/11/10.
//  Copyright © 2015年 Harry. All rights reserved.
//
#import "UITapGestureRecognizer+Data.h"
#import "SummerRepairListsHeaderTableViewCell.h"

@implementation SummerRepairListsHeaderTableViewCell
#define IMG_WIDTH 65
- (void)awakeFromNib {
    // Initialization code
    for (NSInteger index = 0; index < 8; index ++) {
        UIImageView *contentImg = (UIImageView *)[self viewWithTag:index + 1];
        contentImg.userInteractionEnabled = YES;
        UITapGestureRecognizer_Data *tapItem = [[UITapGestureRecognizer_Data alloc] initWithTarget:self action:@selector(imgTap:)];
        tapItem.tapTagImg = index + 1;
        [contentImg addGestureRecognizer:tapItem];
    }
}

- (void)imgTap:(UITapGestureRecognizer_Data *)sender{
    if (self.tapItem) {
        _tapItem(sender.tapTagImg);
    }
}

- (void)confirmTableViewHeaderViewWithData:(TextDeal *)dicTemp{
    [self.cellTitleImageView sd_setImageWithURL:dicTemp.textType[@"logo"] placeholderImage:[UIImage imageNamed:@"loadingLogo"]];
    self.cellTitleName.text = [NSString stringWithFormat:@"%@",dicTemp.textType[@"name"]];
    
    CGFloat contentHeight = [Util getHeightForString:[dicTemp.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] width:SCREENSIZE.width - 30 font:[UIFont systemFontOfSize:15]];
    self.cellImagesView.frame = CGRectMake(10, 60, SCREENSIZE.width - 20, contentHeight + 15);
    
    self.cellContentLab.frame = CGRectMake(5, 0, SCREENSIZE.width - 30, contentHeight);
    
    self.cellContentLab.text = [dicTemp.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for (NSInteger index = 0; index < 8; index ++) {
        UIImageView *img = (UIImageView *)[self.cellImagesView viewWithTag:index + 1];
        img.frame = CGRectZero;
    }
    
    if (![dicTemp.pictures isEqual:[NSNull null]]) {
        if (dicTemp.pictures.count > 0 && [dicTemp.pictures.firstObject length] > 5) {
            CGFloat imgHeight = 0;
            for (int indexPath = 0; indexPath < dicTemp.pictures.count; indexPath ++) {
                UIImageView *imgViewInfo = (UIImageView *)[self.contentView viewWithTag:indexPath + 1];
                [imgViewInfo sd_setImageWithURL:[NSURL URLWithString:dicTemp.pictures[indexPath]] placeholderImage:[UIImage imageNamed:@"loadingLogo"]];
                CGFloat xRow = 5 + (10 + IMG_WIDTH) * (indexPath%4);
                CGFloat yRow = (IMG_WIDTH + 5) * (indexPath/4) + self.cellContentLab.frame.size.height + self.cellContentLab.frame.origin.y + 8;
                imgViewInfo.frame = CGRectMake(xRow, yRow, IMG_WIDTH, IMG_WIDTH);
                imgHeight = yRow + 10;
            }
            if ((dicTemp.pictures.count - 1) > 4) {
                contentHeight += imgHeight*(dicTemp.pictures.count - 1)/4 - 30;
            }else{
                contentHeight += 90;
            }
            
        }
        self.cellImagesView.frame = CGRectMake(10, 60, SCREENSIZE.width - 20, contentHeight);
    }
    
    
    self.cellRepairManView.frame = CGRectMake(10, self.cellImagesView.frame.origin.y + self.cellImagesView.frame.size.height + 5, SCREENSIZE.width - 20, 53);
    
    self.cellRepairPeople.text = [NSString stringWithFormat:@"报修人：%@",dicTemp.creatorInfo[@"nickName"]];
    self.cellPhoneNumber.text  = [NSString stringWithFormat:@"手机号：%@",dicTemp.phone];
    
    
    self.cellRepairTakeNote.frame = CGRectMake(10, self.cellRepairManView.frame.origin.y + self.cellRepairManView.frame.size.height + 10, SCREENSIZE.width - 20, 80);
    NSString *strTemp;
    strTemp = [NSString stringWithFormat:@"维修记录\n%@ 业主报修",dicTemp.createTime];
    if (dicTemp.reciveTime) {
        strTemp = [NSString stringWithFormat:@"维修记录\n%@ 业主报修\n%@  物业确认",dicTemp.createTime,dicTemp.reciveTime];
    }
    self.cellTakeNoteLab.text = strTemp;
    self.cellTakeNoteLab.frame = CGRectMake(10, 8, self.cellRepairTakeNote.frame.size.width - 20, 80);
    self.cellLineLab.frame = CGRectMake(0, self.cellRepairManView.frame.size.height/2, self.cellRepairManView.frame.size.width, .5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end













