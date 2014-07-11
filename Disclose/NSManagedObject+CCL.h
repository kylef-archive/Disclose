#import <CoreData/CoreData.h>

@interface NSManagedObject (CCL)

- (NSArray */* NSString */)ccl_propertyNames;
- (NSString *)disclosureDescription;
- (NSString *)ccl_descriptionForPropertyDescription:(NSPropertyDescription *)propertyDescription;

@end
