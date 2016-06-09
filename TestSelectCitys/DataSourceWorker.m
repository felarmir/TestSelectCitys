//
//  DataSourceWorker.m
//  TestSelectCitys
//
//  Created by Denis Andreev on 09.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import "DataSourceWorker.h"
#import "AppDelegate.h"

@implementation DataSourceWorker
{
    AppDelegate *appDelegate;
}

+(DataSourceWorker*)dataSource{
    static DataSourceWorker *dataSourceObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSourceObject = [[self alloc] init];
    });
    return dataSourceObject;
}

-(NSArray*)cityListRead {
    NSArray *data = [self getDataObject];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSManagedObjectContext *c in data) {
        [tmpArray addObject:[c valueForKey:@"cityName"]];
    }
    return tmpArray;
}

-(NSArray*)getDataObject {
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entDescript = [NSEntityDescription entityForName:@"SelectedCity" inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetchRequest setEntity:entDescript];
    
    NSError *error = nil;
    
    NSArray *result = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetch");
    } else {
        return result;
    }
    return nil;
}

-(BOOL)writeDataOfCity:(NSString*)cityName {
    BOOL isWrite = NO;
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSEntityDescription *entDescript = [NSEntityDescription entityForName:@"SelectedCity" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSManagedObject *objcet = [[NSManagedObject alloc] initWithEntity:entDescript insertIntoManagedObjectContext:appDelegate.managedObjectContext];

    [objcet setValue:cityName forKey:@"cityName"];
    NSError *error;
    if (![objcet.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        isWrite = YES;
    }
    [self cityListRead];

    return isWrite;
}

-(BOOL)deleteCity:(NSString*)cityName
{
    BOOL isDelete = NO;
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *manageObjectContext =[appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SelectedCity" inManagedObjectContext:manageObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    NSArray *result = [manageObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *object = nil;
    
    for(NSManagedObject *obj in result){
        if ([[obj valueForKey:@"cityName"] isEqualToString:cityName]) {
            object = obj;
        }
    }
    [manageObjectContext deleteObject:object];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    if (![manageObjectContext save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    } else {
        isDelete = YES;
    }
    return isDelete;
}

@end
