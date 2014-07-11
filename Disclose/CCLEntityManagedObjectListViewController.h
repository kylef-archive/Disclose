#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CCLEntityManagedObjectListViewController : UITableViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSEntityDescription *entity;
@property (nonatomic, strong) NSPredicate *predicate;

@end
