#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CCLEntityListViewController : UINavigationController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
