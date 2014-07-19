#import <CoreData/CoreData.h>

@interface NSManagedObject (Disclose)

- (NSArray */* NSString */)ccl_propertyNames;
- (NSString *)discloseDescription;
- (NSString *)ccl_descriptionForPropertyDescription:(NSPropertyDescription *)propertyDescription;

@end

