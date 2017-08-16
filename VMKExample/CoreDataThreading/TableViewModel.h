//
//  TableViewModel.h
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import ViewModelKit;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface TableViewModel : VMKViewModel <VMKDataSourceViewModelType>
@property (class, nonatomic, copy, readonly) NSString *runningKeyPath;

@property (nonatomic, assign, readonly) BOOL running;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(nullable id)model NS_UNAVAILABLE;
- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext syncContext:(NSManagedObjectContext *)syncContext NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
