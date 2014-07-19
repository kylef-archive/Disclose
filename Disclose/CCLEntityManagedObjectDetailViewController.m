#import "CCLEntityManagedObjectDetailViewController.h"
#import "CCLEntityManagedObjectListViewController.h"
#import "NSManagedObject+Disclose.h"
#import "NSPropertyDescription+Disclose.h"

@interface CCLEntityManagedObjectDetailViewController ()

@end

@implementation CCLEntityManagedObjectDetailViewController

- (void)dealloc {
    if (self.managedObject) {
        [self removeObserversForManagedObject:self.managedObject];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 50.0;
}

#pragma mark - Properties

- (void)setManagedObject:(NSManagedObject *)managedObject {
    if (_managedObject) {
        [self removeObserversForManagedObject:_managedObject];
    }

    _managedObject = managedObject;

    self.title = [managedObject discloseDescription];

    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }

    if (managedObject) {
        [self addObserversForManagedObject:managedObject];
    }
}

#pragma mark - KVO

static void * CCLEntityManagedObjectObservingContext = &CCLEntityManagedObjectObservingContext;

- (void)addObserversForManagedObject:(NSManagedObject *)managedObject {
    for (NSPropertyDescription *property in managedObject.entity.properties) {
        [managedObject addObserver:self forKeyPath:property.name options:NSKeyValueObservingOptionNew context:CCLEntityManagedObjectObservingContext];
    }
}

- (void)removeObserversForManagedObject:(NSManagedObject *)managedObject {
    for (NSPropertyDescription *property in managedObject.entity.properties) {
        [managedObject removeObserver:self forKeyPath:property.name context:CCLEntityManagedObjectObservingContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == CCLEntityManagedObjectObservingContext) {
        NSPropertyDescription *property = self.managedObject.entity.propertiesByName[keyPath];
        if (property) {
            NSInteger index = [self.managedObject.entity.properties indexOfObject:property];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.managedObject.entity.properties count];
}

- (BOOL)isValueURL:(NSString *)value {
    BOOL isURL = NO;

    if (value && [value rangeOfString:@":"].location != NSNotFound && [value rangeOfString:@" "].location == NSNotFound) {
        NSURL *URL = [NSURL URLWithString:value];
        isURL = URL && [[UIApplication sharedApplication] canOpenURL:URL];
    }

    return isURL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    NSPropertyDescription *property = self.managedObject.entity.properties[indexPath.row];
    NSString *value = [self.managedObject ccl_descriptionForPropertyDescription:property];
    BOOL hasDisclosureIndicator = [self isValueURL:value];

    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        hasDisclosureIndicator = ((NSRelationshipDescription *)property).isToMany || [self.managedObject valueForKey:property.name] != nil;
    }

    cell.textLabel.text = [property discloseLocalizedName];
    cell.detailTextLabel.text = value;
    cell.accessoryType = hasDisclosureIndicator? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPropertyDescription *property = self.managedObject.entity.properties[indexPath.row];
    NSString *value = [self.managedObject ccl_descriptionForPropertyDescription:property];

    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
        NSRelationshipDescription *inverseRelationship = relationship.inverseRelationship;

        if (relationship.isToMany) {
            if (inverseRelationship) {
                CCLEntityManagedObjectListViewController *viewController = [[CCLEntityManagedObjectListViewController alloc] initWithManagedObjectContext:[self.managedObject managedObjectContext]];
                viewController.entity = relationship.destinationEntity;

                if (inverseRelationship.isToMany) {
                    viewController.predicate = [NSPredicate predicateWithFormat:@"ANY %K == %@", inverseRelationship.name, self.managedObject];
                } else {
                    viewController.predicate = [NSPredicate predicateWithFormat:@"%K == %@", inverseRelationship.name, self.managedObject];
                }

                [self.navigationController pushViewController:viewController animated:YES];
            }
        } else {
            NSManagedObject *relatedObject = [self.managedObject valueForKey:property.name];

            if (relatedObject) {
                CCLEntityManagedObjectDetailViewController *relatedViewController = [[CCLEntityManagedObjectDetailViewController alloc] init];
                relatedViewController.managedObject = relatedObject;
                [self.navigationController pushViewController:relatedViewController animated:YES];
            }
        }
    } else if ([self isValueURL:value]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
    }
}

#pragma mark -

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        NSPropertyDescription *property = self.managedObject.entity.properties[indexPath.row];
        NSString *text = [self.managedObject ccl_descriptionForPropertyDescription:property];
        [[UIPasteboard generalPasteboard] setString:text];
    }
}

@end
