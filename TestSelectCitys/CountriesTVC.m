//
//  CountriesTVC.m
//  TestSelectCitys
//
//  Created by Denis Andreev on 08.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import "CountriesTVC.h"
#import "CitysLevelCell.h"
#import "DataSourceWorker.h"
#import "StarButon.h"

#define NAME @"Name"
#define CITY @"Cities"


@interface CountriesTVC () <UIGestureRecognizerDelegate>

@end

@implementation CountriesTVC
{
    NSArray *countries;
    NSMutableArray *collapsSection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    API *api = [[API alloc] init];
    countries = [api.dataFromJSON objectForKey:@"Result"];
    collapsSection = [NSMutableArray  new];
    for(int i = 0; i< [countries count]; i++){
        [collapsSection addObject:@(i)];
    }
    NSLog(@"=%@",[[DataSourceWorker dataSource] cityListRead]);
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HEADER"];
    
    headerCell.textLabel.text = [[countries objectAtIndex:section] objectForKey:NAME];
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headreTap:)];
    [headerCell addGestureRecognizer:headerTap];
    [headerCell setTag:section];
    
    return headerCell;
}

-(void)headreTap:(UITapGestureRecognizer *)sender {
    bool shouldColl = ![collapsSection containsObject:@(sender.view.tag)];
    if (shouldColl) {
            [collapsSection addObject:@(sender.view.tag)];
            [self.tableView reloadData];
    } else {
        [collapsSection removeObject:@(sender.view.tag)];
        [self.tableView reloadData];
    }
    [self.tableView endUpdates];
}

-(NSArray*)indexPathsInSection:(NSInteger)section rowNumbers:(NSInteger)rows{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    if (rows > 0) {
        for (int i = 0; i < rows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![collapsSection containsObject:@(section)]) {
        return [[[countries objectAtIndex:section] objectForKey:CITY] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *IDENT = @"Countries";

     CitysLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENT forIndexPath:indexPath];
    if (!cell) {
        cell = [[CitysLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENT];
    }
    NSString *cityName = [[[[countries objectAtIndex:indexPath.section] objectForKey:CITY] objectAtIndex:indexPath.row] objectForKey:NAME];
    cell.cityLabel.text = cityName;
    cell.selectButon.indexPath = indexPath;
    
    [cell.selectButon addTarget:self action:@selector(addRemuveCity:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[DataSourceWorker dataSource] cityListRead] containsObject:cityName]) {
        [cell.selectButon setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [cell setBackgroundColor:[UIColor grayColor]];
    } else {
        [cell.selectButon setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    [cell setIndentationLevel:2];
    return cell;
}

-(void)addRemuveCity:(StarButon*)sender {
    NSString *cityName = [[[[countries objectAtIndex:sender.indexPath.section] objectForKey:CITY] objectAtIndex:sender.indexPath.row] objectForKey:NAME];
    CitysLevelCell *cell = [self.tableView cellForRowAtIndexPath:sender.indexPath];
    if(![[[DataSourceWorker dataSource] cityListRead] containsObject:cityName]) {
        if([[DataSourceWorker dataSource] writeDataOfCity:cityName]){
            [cell.selectButon setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
    } else {
        if ([[DataSourceWorker dataSource] deleteCity:cityName]) {
            [cell.selectButon setImage:[UIImage imageNamed:@"unselect.png"] forState:UIControlStateNormal];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}


@end
