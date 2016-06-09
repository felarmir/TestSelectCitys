//
//  CitysLevelCell.h
//  TestSelectCitys
//
//  Created by Denis Andreev on 09.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarButon.h"

@interface CitysLevelCell : UITableViewCell

@property (nonatomic, strong) IBOutlet StarButon *selectButon;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;

@end
