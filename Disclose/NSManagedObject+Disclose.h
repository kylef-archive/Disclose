#import <CoreData/CoreData.h>

@interface NSManagedObject (Disclose)

/*** Returns a string that describes the contents of the receiver.
 @return A string that describes the contents of the receiver.
 */
- (NSString *)discloseDescription;

/*** Returns a string that describes the contents of a property.
 @return A string that describes the contents of the received property.
 */
- (NSString *)discloseDescriptionForPropertyDescription:(NSPropertyDescription *)propertyDescription;

@end
