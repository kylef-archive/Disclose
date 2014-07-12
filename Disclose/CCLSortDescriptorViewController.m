#import "CCLSortDescriptorViewController.h"
#import "NSEntityDescription+Disclose.h"
#import "NSPropertyDescription+Disclose.h"

@interface CCLSortDescriptorInternalViewController : UITableViewController

@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, copy) NSArray *attributes;

@end

@implementation CCLSortDescriptorViewController

- (instancetype)init {
    return [super initWithRootViewController:[[CCLSortDescriptorInternalViewController alloc] init]];
}

- (void)setEntity:(NSEntityDescription *)entity {
    [[self.viewControllers firstObject] setEntity:entity];
}

@end

@implementation CCLSortDescriptorInternalViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark -

- (void)setEntity:(NSEntityDescription *)entity {
    _entity = entity;

    NSMutableArray *attributes = [NSMutableArray array];
    NSArray *defaultOrder = [[entity discloseDefaultSortDescriptors] valueForKey:NSStringFromSelector(@selector(key))];
    for (NSString *key in defaultOrder) {
        NSPropertyDescription *property = entity.propertiesByName[key];
        [attributes addObject:property];
    }
    self.attributes = attributes;

    if ([self isViewLoaded]) {
        [self.tableView reloadData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Sorting";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.tableView.editing = YES;
}

- (void)done {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.attributes count];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *attributes = [self.attributes mutableCopy];
    NSAttributeDescription *attribute = attributes[fromIndexPath.row];
    [attributes removeObject:attribute];
    [attributes insertObject:attribute atIndex:toIndexPath.row];
    self.attributes = attributes;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    NSAttributeDescription *attribute = self.attributes[indexPath.row];
    cell.textLabel.text = [attribute discloseLocalizedName];

    return cell;
}

@end