//
//  Page.h
//  cling
//
//  Created by suer on 2014/09/12.
//  Copyright (c) 2014年 codefirst.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * sort;

@end
