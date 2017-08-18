//
//  FakeNotificationCenter.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "FakeNotificationCenter.h"

@interface FakeNotificationCenter ()
@property (assign, nonatomic, readwrite) NSUInteger addObserverForNameCallCount;
@property (assign, nonatomic, readwrite) NSUInteger removeObserverCallCount;
@end

@implementation FakeNotificationCenter

- (id)addObserverForName:(NSString *)name object:(id)object queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *))block {
    ++self.addObserverForNameCallCount;
    return self.addObserverForNameReturnObject;
}

- (void)removeObserver:(id)notificationObserver {
    ++self.removeObserverCallCount;
}

@end
