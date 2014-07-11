#import "CCLEntityListViewController.h"
#import "CCLEntityManagedObjectListViewController.h"

@implementation CCLEntityListViewController

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model context:(NSManagedObjectContext *)context {
    if (self = [super init]) {
        _model = model;
        _managedObjectContext = context;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Entities";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    self.tableView.rowHeight = 50.0;
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
    cell.textLabel.text = entity.name;

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