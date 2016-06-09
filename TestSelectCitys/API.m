//
//  API.m
//  MuzIzdat
//
//  Created by Denis Andreev on 27.12.15.
//  Copyright © 2015 Denis Andreev. All rights reserved.
//

#import "API.h"

@implementation API

-(NSDictionary*)dataFromJSON
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://atw-backend.azurewebsites.net/api/countries"]];
    NSData *jsonData = [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    
    return results;
}

@end
