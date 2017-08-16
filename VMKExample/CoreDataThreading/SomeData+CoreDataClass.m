//
//  SomeData+CoreDataClass.m
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SomeData+CoreDataClass.h"

@implementation SomeData

+ (NSFetchRequest<SomeData *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"SomeData"];
}

@dynamic title;
@dynamic subtitle;
@dynamic imageName;

@end
