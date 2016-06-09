//
//  FavoriteTVC.m
//  TestSelectCitys
//
//  Created by Denis Andreev on 08.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import "FavoriteTVC.h"
#import "DataSourceWorker.h"
#import "FavoriteCell.h"

@interface FavoriteTVC ()

@end

@implementation FavoriteTVC
{
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[DataSourceWorker dataSource] cityListRead];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated {
    dataArray = [[DataSourceWorker dataSource] cityListRead];
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArray count] > 0) {
        return [dataArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *IDENT = @"CityList"; 
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENT forIndexPath:indexPath];
    if(!cell){
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENT];
    }
    
    cell.cityLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.delButon.tag = indexPath.row;
    [cell.delButon addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)deleteRow:(UIButton*)sender {
    if([[DataSourceWorker dataSource] deleteCity:[dataArray objectAtIndex:sender.tag]]){
        [self.tableView beginUpdates];
        [dataArray removeObjectAtIndex:sender.tag];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }
}

@end
