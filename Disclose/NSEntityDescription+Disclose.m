#import "CCLUtilities.h"
#import "NSEntityDescription+Disclose.h"

@implementation NSEntityDescription (Disclose)

- (NSString *)discloseLocalizedName {
    NSString *entityName = self.name;

    NSString *localizedKey = [@"Entity/" stringByAppendingString:entityName];
    NSString *localizedEntityName = self.managedObjectModel.localizationDictionary[localizedKey];

    if (localizedEntityName) {
        entityName = localizedEntityName;
    } else {
        entityName = CCLCamelCaseToSpaces(entityName);
    }

    return entityName;
}

@end
