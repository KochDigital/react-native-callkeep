#import <Foundation/Foundation.h>

@interface PjSipCustomStringArray : NSObject

@property (nonatomic, strong) NSMutableArray<NSString *> *array;
@property (nonatomic, assign) NSUInteger capacity;

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (void)push:(NSString *)string;
- (BOOL)containsString:(NSString *)string;

@end