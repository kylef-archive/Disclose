#import <CoreData/CoreData.h>

@interface NSManagedObject (CCL)

- (NSArray */* NSString */)ccl_propertyNames;
- (NSString *)ccl_name;
- (NSString *)ccl_descriptionForPropertyDescription:(NSPropertyDescription *)propertyDescription;

@end
