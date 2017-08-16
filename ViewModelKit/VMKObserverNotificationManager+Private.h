//
//  VMKObserverNotificationManager+Private.h
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKObserverNotificationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface VMKObserverNotificationManager ()
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) NSMutableDictionary *noteObservers;

- (void)addObserver:(id)observerObject name:(nullable NSString *)notificationName object:(nullable id)notificationSender;
- (void)removeObserverFromSender:(nullable NSMutableDictionary *)senders forObject:(nullable id)object;

- (NSString *)noteKey:(nullable NSString *)notificationName;
- (NSString *)senderKey:(nullable NSString *)notificationSender;
@end

NS_ASSUME_NONNULL_END
