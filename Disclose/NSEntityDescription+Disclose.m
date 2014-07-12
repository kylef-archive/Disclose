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

- (NSArray *)discloseDefaultSortDescriptors {
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSPropertyDescription *property in self.properties) {
        if ([property isKindOfClass:[NSAttributeDescription class]] && [property isTransient] == NO && [property isStoredInExternalRecord] == NO) {
            [attributes addObject:property];
        }
    }

    NSArray *sortedKeys = [[attributes sortedArrayUsingDescriptors:@[
        [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:^NSComparisonResult(NSAttributeDescription *obj1, NSAttributeDescription *obj2) {
            if ([obj1 attributeType] == NSDateAttributeType && [obj2 attributeType] == NSDateAttributeType) {
                return NSOrderedSame;
            } else if ([obj1 attributeType] == NSDateAttributeType) {
                return NSOrderedAscending;
            } else if ([obj2 attributeType] == NSDateAttributeType) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }],
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(isIndexed)) ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES comparator:^NSComparisonResult(id name1, id name2) {
            BOOL is1Title = [name1 isEqualToString:@"title"];
            BOOL is2Title = [name2 isEqualToString:@"title"];
            BOOL is1Name = [name1 isEqualToString:@"name"];
            BOOL is2Name = [name2 isEqualToString:@"name"];

            if ((is1Title && is2Title) || (is1Name && is2Name)) {
                return NSOrderedSame;
            } else if (is1Title || is1Name) {
                return NSOrderedAscending;
            } else if (is2Title || is2Name) {
                return NSOrderedDescending;
            }

            return NSOrderedSame;
        }],
        [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name)) ascending:YES],
    ]] valueForKey:@"name"];

    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]];
    }
    return [sortDescriptors copy];
}

@end
