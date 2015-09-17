#import "CCLUtilities.h"
#import "NSPropertyDescription+Disclose.h"

@implementation NSPropertyDescription (Disclose)

- (NSString *)discloseLocalizedName {
    NSString *name;

    NSDictionary *localizationDictionary = self.entity.managedObjectModel.localizationDictionary;
    NSString *propertyKey = [@"Property/" stringByAppendingString:self.name];
    NSString *propertyEntityKey = [NSString stringWithFormat:@"%@/Entity/%@", propertyKey, self.entity.name];

    if (localizationDictionary[propertyEntityKey]) {
        name = localizationDictionary[propertyEntityKey];
    } else if (localizationDictionary[propertyKey]) {
        name = localizationDictionary[propertyKey];
    } else {
        name = [CCLCamelCaseToSpaces(self.name) capitalizedString];
    }

    return name;
}

@end
