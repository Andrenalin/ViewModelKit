//
//  VMKView.h
//  ViewModelKit
//
//  Created by Andre Trettin on 15/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface VMKView : UIView
@property (nonatomic, assign) IBInspectable CGSize preferedSize;
@end

NS_ASSUME_NONNULL_END
