#import "NSManagedObject+Disclose.h"

@implementation NSManagedObject (Disclose)

- (NSArray *)ccl_propertyNames {
    return [self.entity.properties valueForKey:NSStringFromSelector(@selector(name))];
}

- (NSString *)discloseDescription {
    NSString *name;
    NSArray *properties = [self ccl_propertyNames];

    for (NSString *property in @[@"name", @"title"]) {
        if ([properties containsObject:property]) {
            name = [self valueForKey:property];

            if (name && [name length] > 0) {
                break;
            }
        }
    }

    if (name == nil || [name length] == 0) {
        name = [[self objectID] description];
    }

    return name;
}

- (NSString *)discloseDescriptionForPropertyDescription:(NSPropertyDescription *)propertyDescription {
    NSString *description;
    id value = [self valueForKey:propertyDescription.name];

    if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;

        if (relationship.isToMany) {
            NSSet *objects = value;
            NSUInteger count = [objects count];

            if (count == 1) {
                description = [NSString stringWithFormat:@"%@ object", @(count)];
            } else {
                description = [NSString stringWithFormat:@"%@ objects", @(count)];
            }
        } else {
            if (value) {
                NSManagedObject *relatedObject = value;
                description = [relatedObject discloseDescription];
            } else {
                description = @"None";
            }
        }
    } else if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
        NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

        switch (attributeDescription.attributeType) {
            case NSBooleanAttributeType: {
                if (value) {
                    description = [value boolValue] ? @"Yes" : @"No";
                } else {
                    description = @"Unset";
                }
                break;
            }
            default:
                description = [value description];
        }
    } else {
        description = [value description];
    }

    return description;
}

@end
