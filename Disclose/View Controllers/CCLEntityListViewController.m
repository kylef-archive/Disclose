#import "CCLEntityListViewController.h"
#import "CCLEntityManagedObjectListViewController.h"
#import "CCLDisclosureAboutViewController.h"
#import "NSEntityDescription+Disclose.h"


@interface CCLEntityListInternalViewController : UITableViewController

@property (nonatomic, strong, readonly) NSManagedObjectModel *model;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end

@implementation CCLEntityListViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    UIViewController *viewController = [[CCLEntityListInternalViewController alloc] initWithManagedObjectContext:context];

    if (self = [self initWithRootViewController:viewController]) {
        _managedObjectContext = context;
    }

    return self;
}

@end

@implementation CCLEntityListInternalViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    if (self = [super init]) {
        _managedObjectContext = context;
        _model = context.persistentStoreCoordinator.managedObjectModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Entities";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(showAbout)];

    self.tableView.rowHeight = 50.0;
}

- (void)showAbout {
    UIViewController *viewController = [[CCLDisclosureAboutViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.entities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSEntityDescription *entity = self.model.entities[indexPath.row];

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [entity discloseLocalizedName];
    cell.accessibilityLabel = [entity discloseLocalizedName];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity.name];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];

    if (count == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ object", @(count)];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ objects", @(count)];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLEntityManagedObjectListViewController *viewController = [[CCLEntityManagedObjectListViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    viewController.entity = self.model.entities[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end