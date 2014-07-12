#import "NSPropertyDescription+Disclose.h"

@implementation NSPropertyDescription (Disclose)

- (NSString *)discloseLocalizedName {
    NSString *name = self.name;

    NSDictionary *localizationDictionary = self.entity.managedObjectModel.localizationDictionary;
    NSString *propertyKey = [@"Property/" stringByAppendingString:name];
    NSString *propertyEntityKey = [NSString stringWithFormat:@"%@/Entity/%@", propertyKey, self.entity.name];

    if (localizationDictionary[propertyEntityKey]) {
        name = localizationDictionary[propertyEntityKey];
    } else if (localizationDictionary[propertyKey]) {
        name = localizationDictionary[propertyKey];
    }

    return name;
}

@end
