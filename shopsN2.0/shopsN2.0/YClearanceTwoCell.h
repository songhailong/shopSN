//
//  YClearanceTwoCell.h
//  shopsN
//
//  Created by imac on 2016/12/9.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGoodsModel.h"

@interface YClearanceTwoCell : UICollectionViewCell

@property (strong,nonatomic) YGoodsModel *model;

@property (strong,nonatomic) NSString *disCount;

@end