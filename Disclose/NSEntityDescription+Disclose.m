#import "NSEntityDescription+Disclose.h"

@implementation NSEntityDescription (Disclose)

- (NSString *)discloseLocalizedName {
    NSString *entityName = self.name;

    NSString *localizedKey = [@"Entity/" stringByAppendingString:entityName];
    NSString *localizedEntityName = self.managedObjectModel.localizationDictionary[localizedKey];

    return localizedEntityName ? localizedEntityName : entityName;
}

@end
