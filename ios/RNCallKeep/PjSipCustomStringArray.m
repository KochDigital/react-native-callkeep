#import "PjSipCustomStringArray.h"

@implementation PjSipCustomStringArray

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
        _capacity = capacity;
    }
    return self;
}

- (void)push:(NSString *)string {
    if (self.array.count < self.capacity) {
        [self.array addObject:string];
    } else {
        [self.array removeObjectAtIndex:0];
        [self.array addObject:string];
    }
}

- (BOOL)containsString:(NSString *)string {
    return [self.array containsObject:string];
}

@end