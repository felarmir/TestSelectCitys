//
//  DataSourceWorker.h
//  TestSelectCitys
//
//  Created by Denis Andreev on 09.06.16.
//  Copyright © 2016 Denis Andreev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSourceWorker : NSObject

+(DataSourceWorker*)dataSource;
-(NSArray*)cityListRead;
-(BOOL)writeDataOfCity:(NSString*)cityName;
-(BOOL)deleteCity:(NSString*)cityName;

@end
