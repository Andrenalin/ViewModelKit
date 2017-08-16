//
//  VMKObservable.h
//  ViewModelKit
//
//  Created by Andre Trettin on 24.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

@class VMKBindingUpdater;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief The default option for the KVO that is used by the init without any options.
 
 The default options is on any new values and the initial set.
 */
extern NSUInteger const VMKObservableDefaultKVOOptions;


/**
 @brief The VMKObservable class binds an object with a keypath to the VMKBindingUpdater instance.
 */
@interface VMKObservable : NSObject

/**
 @brief This flag is set if the observable is observing the object on its keypath.
 */
@property (nonatomic, assign, readonly, getter=isObserving) BOOL observing;

- (instancetype)init NS_UNAVAILABLE;

/**
 @brief Initialises the instance with an object a keypath to observe and the binding updater instance.

 @param object The object will be observed.
 @param keyPath The keyPath must be a readwrite property or an ivar to observe on the object.
 @param bindingUpdater The bindingUpdater wraps the object that got called if the value of the keyPath from the object has changed.
 @return A VMKObserable instance.
 */
- (instancetype)initWithObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater;

/**
 @brief Initialises the instance with an object a keypath to observe and the binding updater instance.
 
 @param object The object will be observed.
 @param keyPath The keyPath must be a readwrite property or an ivar to observe on the object.
 @param bindingUpdater The bindingUpdater wraps the object that got called if the value of the keyPath from the object has changed.
 @param options The options determine what changes will inform the bindingUpdater.
 @return A VMKObserable instance.
 */
- (instancetype)initWithObject:(id)object forKeyPath:(NSString *)keyPath bindingUpdater:(VMKBindingUpdater *)bindingUpdater options:(NSKeyValueObservingOptions)options NS_DESIGNATED_INITIALIZER;


/**
 @brief Starts the observation of the keyPath from the object and informs the bindingUpdater.
 @discussion The method has to be called once after the init to start the KVO, otherwise the bindingUpdater will not inform at all. A second call does noting.
 */
- (void)startObservation;

/**
 @brief Is the keyPath the same one of this instance.
 @param keyPath The keyPath will be checked if it is the observed one.
 @return Whether the keyPaths are equal or not.
 */
- (BOOL)isKeyPath:(NSString *)keyPath;

/**
 @brief Is the observer the same of the bindingUpdater of this instance.
 @param observer The observer will be checked if it is the one that gets notified.
 @return Whether the observers are equal or not.
 */
- (BOOL)isObserver:(id)observer;

/**
 @brief Is the object the same one of this instance.
 @param object The object will be checked if it is the one that gets observed.
 @return Whether the objects are equal or not.
 */
- (BOOL)isObject:(id)object;
@end

NS_ASSUME_NONNULL_END
