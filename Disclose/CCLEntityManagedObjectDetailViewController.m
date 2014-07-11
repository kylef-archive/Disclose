#import "CCLEntityManagedObjectDetailViewController.h"
#import "NSManagedObject+CCL.h"

@interface CCLEntityManagedObjectDetailViewController ()

@end

@implementation CCLEntityManagedObjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 50.0;
}

- (void)setManagedObject:(NSManagedObject *)managedObject {
    _managedObject = managedObject;

    self.title = [managedObject disclosureDescription];

    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.managedObject.entity.properties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    NSPropertyDescription *property = self.managedObject.entity.properties[indexPath.row];
    BOOL isRelationship = [property isKindOfClass:[NSRelationshipDescription class]];

    cell.textLabel.text = property.name;
    cell.detailTextLabel.text = [self.managedObject ccl_descriptionForPropertyDescription:property];
    cell.accessoryType = isRelationship? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPropertyDescription *property = self.managedObject.entity.properties[indexPath.row];

    if ([property isKindOfClass:[NSRelationshipDescription class]]) {
        NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;

        if (relationship.isToMany) {
            // TODO list of managed object with this filter
        } else {
            NSManagedObject *relatedObject = [self.managedObject valueForKey:property.name];

            if (relatedObject) {
                CCLEntityManagedObjectDetailViewController *relatedViewController = [[CCLEntityManagedObjectDetailViewController alloc] init];
                relatedViewController.managedObject = relatedObject;
                [self.navigationController pushViewController:relatedViewController animated:YES];
            }
        }
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
