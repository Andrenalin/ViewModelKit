//
//  VMKTableViewDelegate.h
//  ViewModelKit
//
//  Created by Andre Trettin on 02.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewDelegate : NSObject <UITableViewDelegate>
// pass through the delegate request from the tableview to a viewcontroller
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
