//
//  TableViewController.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

- (NSString *)dataSource:(VMKTableViewDataSource *)dataSource
        cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"CustomCell";
}

@end
