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

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = entity.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCLEntityManagedObjectListViewController *viewController = [[CCLEntityManagedObjectListViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    viewController.entity = self.model.entities[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end