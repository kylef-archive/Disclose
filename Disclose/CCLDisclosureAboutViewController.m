#import "CCLDisclosureAboutViewController.h"

@implementation CCLDisclosureAboutViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Disclose";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;

    switch (section) {
        case 0:
            count = 2;
            break;
        case 1:
            count = 1;
            break;
    }

    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0)? @"Info" : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (section == 1)? @"This is a private beta. We really appreciate you involvement, but please don't share any details or beta builds publicly." : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Version";
                    cell.detailTextLabel.text = @"0.1.0 (Preview)";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Website";
                    cell.detailTextLabel.text = @"cocode.org";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
            break;
        }

        case 1:
            cell.textLabel.text = @"Send Feedback";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@cocode.org"]];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://cocode.org/"]];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
