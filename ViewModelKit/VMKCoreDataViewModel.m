//
//  VMKCoreDataViewModel.m
//  ViewModelKit
//
//  Created by Andre Trettin on 24/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKCoreDataViewModel+Private.h"

@implementation VMKCoreDataViewModel

#pragma mark - save

- (BOOL)saveCoreDataObject:(NSError *__autoreleasing *)error {
    if (self.model) {
        __kindof NSManagedObject *model = self.model;
        return [model.managedObjectContext save:error];
    }
    return YES;
}

#pragma mark - editing

- (void)deleteObject {
    if (self.model) {
        NSManagedObject *object = self.model;
        self.model = nil;
        [object.managedObjectContext deleteObject:object];
    }
}

- (void)resetObject:(NSManagedObject *)object {
    self.model = object;
}

@end
