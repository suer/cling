#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * createdAt;

@end
