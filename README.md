# Disclose

Disclose is a way to expose and view your managed objects in Core Data in a
user interface.

## Usage

Once you've installed Disclose into your project, you will need to invoke it,
passing it a managed object context on the main queue and then present
the view controller.

### Swift

```swift
import Disclose

class MyViewController : UIViewController {
  func presentDisclose() {
    let viewController = CCLEntityListViewController(managedObjectContext: context)
    presentViewController(viewController, animated: true, completion: nil)
  }
}
```

### Objective-C

```objective-c
#import <Disclose/Disclose.h>

@implementation MyViewController

- (void)presentDisclose {
  NSManagedObjectContext *context = /* Create a managed object context to use with Disclose */;
  CCLEntityListViewController *viewController = [[CCLEntityListViewController alloc] initWithManagedObjectContext:context];
  [self presentViewController:viewController animated:YES completion:nil];
}

@end
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add Disclose to your project.

```ruby
pod 'Disclose'
```

With CocoaPods, you can specify a configuration so that Disclose isn't
included in your application releases and only debug builds.

```ruby
pod 'Disclose', :configurations => ['Debug']
```

## Frequently Asked Questions

##### I want to change the name in the user interface for an entity or property?

You can set the [localizationDictionary](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSManagedObjectModel_Class/Reference/Reference.html#//apple_ref/occ/instm/NSManagedObjectModel/setLocalizationDictionary:) property on your managed object model to include localized names for these properties.

```objective-c
[managedObjectModel setLocalizationDictionary:@{
    @"Entity/FFGPerson": "Person",
    @"Property/image_url": @"Image URL",
}];
```

##### I want to show a custom description for my managed objects instead of `<NSManagedObject 0xADDRESS> ...`

You can implement the `discloseDescription` method on a category for your managed object subclass providing a description.

```swift
extension User {
  func discloseDescription() -> String {
    return username
  }
}
```

```objective-c
@implementation User (Disclose)

- (NSString *)discloseDescription {
    return self.username;
}

@end
```

## License

Disclose is released under the BSD license. See [LICENSE](LICENSE).

