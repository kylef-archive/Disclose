#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CCLEntityListViewController : UITableViewController

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)model context:(NSManagedObjectContext *)context;

@property (nonatomic, strong, readonly) NSManagedObjectModel *model;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end

