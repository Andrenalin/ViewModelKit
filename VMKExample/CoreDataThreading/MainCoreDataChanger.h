//
//  MainCoreDataChanger.h
//  VMKExample
//
//  Created by Andre Trettin on 08/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface MainCoreDataChanger : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
