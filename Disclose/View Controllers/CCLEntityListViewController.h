#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EntityListViewController : UINavigationController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
