#import "CCLEntityManagedObjectListViewController.h"
#import "CCLEntityManagedObjectDetailViewController.h"
#import "CCLSortDescriptorViewController.h"
#import "NSManagedObject+CCL.h"
#import "NSEntityDescription+Disclose.h"

@interface CCLEntityManagedObjectListViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CCLEntityManagedObjectListViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(handleSort)];
}

- (void)setEntity:(NSEntityDescription *)entity {
    _entity = entity;
    self.title = [entity discloseLocalizedName];
    [self loadData];
}

- (void)setPredicate:(NSPredicate *)predicate {
    _predicate = predicate;
    [self loadData];
}

- (void)loadData {
    if (self.fetchedResultsController) {
        self.fetchedResultsController.delegate = nil;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entity.name];
    fetchRequest.sortDescriptors = [self.entity discloseDefaultSortDescriptors];
    fetchRequest.predicate = self.predicate;
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:nil];
    self.fetchedResultsController = fetchedResultsController;

    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}

#pragma mark -

- (void)handleSort {
    CCLSortDescriptorViewController *viewController = [[CCLSortDescriptorViewController alloc] init];
    viewController.entity = self.entity;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = [self.fetchedResultsController.sections count];

    return (NSInteger)count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self sectionInfoForSection:section];
    return (NSInteger)sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSManagedObject *managedObject = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = [managedObject disclosureDescription];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            NSManagedObject *managedObject = [self objectAtIndexPath:indexPath];
            [self.managedObjectContext deleteObject:managedObject];

            NSError *error;
            if ([self.managedObjectContext save:&error] == NO) {
                NSLog(@"Disclose: Failed to save managed object context after deleting %@", error);
            }

            break;
        }

        case UITableViewCellEditingStyleInsert:
            break;
        case UITableViewCellEditingStyleNone:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLEntityManagedObjectDetailViewController *viewController = [[CCLEntityManagedObjectDetailViewController alloc] init];
    viewController.managedObject = [self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -

- (id <NSFetchedResultsSectionInfo>)sectionInfoForSection:(NSUInteger)section {
    return self.fetchedResultsController.sections[section];
}

- (id <NSObject>)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self sectionInfoForSection:indexPath.section].objects[indexPath.row];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
