//
//  VMKObserverNotificationManager.h
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN


/**
 @brief The observer notifcation manager class is a manager of taking care about observable objects from the notification center.
 
 The manager is using the main queue to execute the blocks. The default init is using the default NotificationCenter.
 */
@interface VMKObserverNotificationManager : NSObject

/** @brief Initializes the instance with a notification center object.
 
  @discussion The init is using the default NotificationCenter instance for observing notifications.
 
  @param notificationCenter The notification center where all observables are attached to.
  @return Returns an ObserverNotificationManager.
 */
- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter NS_DESIGNATED_INITIALIZER;

/** @brief Adds an observer for the notification name of the object to execute the block.
 
 @param notificationName The name of the notification for which to register the observer; that is, only notifications with this name are used to add the block to the operation queue.
 
 If you pass nil, the notification center doesn’t use a notification’s name to decide whether to add the block to the operation queue.
 
 @param notificationSender The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer. 
 
 If you pass nil, the notification center doesn’t use a notification’s sender to decide whether to deliver it to the observer.

 @param block The block to be executed when the notification is received.
 The block is copied by the notification center and (the copy) held until the observer registration is removed.
 
 @discussion The paramater are the same as calling directly the NotificationCeneter method.
 */
- (void)addObserverForName:(nullable NSString *)notificationName object:(nullable id)notificationSender usingBlock:(void (^)(NSNotification *notification))block;

/**
 @brief Removes all observers.
 */
- (void)removeObservers;

/**
 @brief Removes the observer with notification name of sender object.
 
 @param notificationName Name of the notification to remove from dispatch table. Specify a notification name to remove only entries that specify this notification name. When nil, all observers of the notification sender will be removed.
 @param notificationSender Sender to remove from the dispatch table. Specify a notification sender to remove only entries that specify this sender. When nil, the name will be used as criteria.
 
 @discussion If both parameter are nil all observers will be removed. The removeObservers has better performance.
 */
- (void)removeObserverWithName:(nullable NSString *)notificationName object:(nullable id)notificationSender;
@end

NS_ASSUME_NONNULL_END
