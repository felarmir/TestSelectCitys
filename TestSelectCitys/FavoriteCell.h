//
//  FavoriteCell.h
//  TestSelectCitys
//
//  Created by Denis Andreev on 09.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarButon.h"

@interface FavoriteCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *delButon;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;


@end
