#import "CCLUtilities.h"

NSString *CCLCamelCaseToSpaces(NSString *string) {
    static NSRegularExpression *expression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error;
        expression = [NSRegularExpression regularExpressionWithPattern:@"(((?<=[a-z])[A-Z])|([A-Z](?![A-Z]|$)))" options:0 error:&error];

        if (expression == nil) {
            NSLog(@"Disclose: Failed to regex: %@", error);
        }
    });

    NSMutableString *result = [string mutableCopy];
    [expression replaceMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:@" $1"];
    return [result copy];
}
