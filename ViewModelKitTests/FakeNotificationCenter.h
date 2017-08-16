//
//  FakeNotificationCenter.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

@interface FakeNotificationCenter : NSObject

#pragma mark - addObserverForName:object:queue:usingBlock:

@property (strong, nonatomic) id addObserverForNameReturnObject;
@property (assign, nonatomic, readonly) NSUInteger addObserverForNameCallCount;

- (id)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *))block;

#pragma mark - removeObserver

@property (assign, nonatomic, readonly) NSUInteger removeObserverCallCount;

- (void)removeObserver:(id)notificationObserver;

@end
