//
//  SummerComplainDetailHeaderTableViewCell.h
//  WeCommunity
//
//  Created by madarax on 15/11/8.
//  Copyright © 2015年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextDeal.h"

@interface SummerComplainDetailHeaderTableViewCell : UITableViewCell

@property(nonatomic ,weak)IBOutlet UIImageView *cellHeaderUserImg;
@property(nonatomic ,weak)IBOutlet UILabel *cellHeaderName;
@property(nonatomic ,weak)IBOutlet UILabel *cellHeaderContent;
@property(nonatomic ,weak)IBOutlet UILabel *cellHeaderTime;
@property(nonatomic ,weak)IBOutlet UIButton *cellHeaderReplayBtn;
- (void)confirmCellInformationWithData:(TextDeal *)dicTemp;
- (void)confirmCellCompliteDetailWithData:(TextDeal *)dicTemp;/**<cell model*/
@end