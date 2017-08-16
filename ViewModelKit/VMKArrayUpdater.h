//
//  VMKArrayUpdater.h
//  ViewModelKit
//
//  Created by Andre Trettin on 21/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKArrayModel.h"

@class VMKArrayUpdater;
@class VMKChangeSet;

NS_ASSUME_NONNULL_BEGIN

@protocol VMKArrayUpdaterDelegate <NSObject>
- (void)arrayUpdater:(VMKArrayUpdater *)arrayUpdater didChangeWithChangeSet:(VMKChangeSet *)changeSet;
@end

@interface VMKArrayUpdater<__covariant ObjectType> : NSObject
@property (nonatomic, weak) id<VMKArrayUpdaterDelegate> delegate;
@property (nonatomic, strong, readonly) VMKArrayModel<ObjectType> *arrayModel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithArrayModel:(VMKArrayModel<ObjectType> *)arrayModel delegate:(nullable id<VMKArrayUpdaterDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)bindArray;
@end

NS_ASSUME_NONNULL_END
