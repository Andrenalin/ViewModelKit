//
//  VMKObserverNotificationManager.m
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKObserverNotificationManager+Private.h"

@implementation VMKObserverNotificationManager

#pragma mark - init

- (void)dealloc {
    [self removeObservers];
}

- (instancetype)init {
    return [self initWithNotificationCenter:[NSNotificationCenter defaultCenter]];
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter {
    self = [super init];
    if (self) {
        _notificationCenter = notificationCenter;
    }
    return self;
}

- (NSMutableDictionary *)noteObservers {
    if (_noteObservers) {
        return _noteObservers;
    }
    _noteObservers = [[NSMutableDictionary alloc] init];
    return _noteObservers;
}

#pragma mark - public interface

- (void)addObserverForName:(NSString *)notificationName object:(id)notificationSender usingBlock:(void (^)(NSNotification *note))block {

    id observerObject = [self.notificationCenter addObserverForName:notificationName object:notificationSender queue:[NSOperationQueue mainQueue] usingBlock:block];

    [self addObserver:observerObject name:notificationName object:notificationSender];
}

- (void)removeObservers {
    [self removeObserverWithName:nil object:nil];
}

- (void)removeObserverWithName:(NSString *)notificationName object:(id)notificationSender {
    
    if (notificationName) {
        NSString *noteKey = [self noteKey:notificationName];
        [self removeObserverFromSender:self.noteObservers[noteKey] forObject:notificationSender];
    } else {
        for (NSMutableDictionary *senders in [self.noteObservers allValues]) {
            [self removeObserverFromSender:senders forObject:notificationSender];
        }
    }
}

#pragma mark - private interface

- (void)addObserver:(id)observerObject name:(NSString *)notificationName object:(id)notificationSender {
    
    NSString *noteKey = [self noteKey:notificationName];
    NSString *senderKey = [self senderKey:notificationSender];

    NSMutableDictionary *senderObservers = self.noteObservers[noteKey];

    if (senderObservers) {
        id observer = senderObservers[senderKey];
        if (observer) {
            [self.notificationCenter removeObserver:observer];

            NSLog(@"Attention: You are going to overwrite the observer for %@ with object %@", notificationName, notificationSender);
        }
        senderObservers[senderKey] = observerObject;
    } else {
        senderObservers = [ @{ senderKey: observerObject } mutableCopy ];
        self.noteObservers[noteKey] = senderObservers;
    }
}

- (void)removeObserverFromSender:(NSMutableDictionary *)senders forObject:(id)object {
    
    if (object) {
        NSString *senderKey = [self senderKey:object];
        id observer = senders[senderKey];
        if (observer) {
            [self.notificationCenter removeObserver:observer];
        }
        [senders removeObjectForKey:senderKey];
    } else {
        for (id observer in [senders allValues]) {
            [self.notificationCenter removeObserver:observer];
        }
        [senders removeAllObjects];
    }
}

- (NSString *)noteKey:(NSString *)notificationName {
    
    NSString *noteKey = notificationName;
    if (!noteKey) {
        noteKey = @"ObserverNotificationManagerNoteKey-PM1-ad-kVV";
    }
    return noteKey;
}

- (NSString *)senderKey:(id)notificationSender {
    
    NSString *senderKey = nil;
    if (notificationSender) {
        senderKey = [[NSString alloc] initWithFormat:@"%tu", [notificationSender hash]];
    } else {
        senderKey = @"ObserverNotificationManagerSenderKey-ge0-IT-jLq";
    }
    return senderKey;
}

@end
