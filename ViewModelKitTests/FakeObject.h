//
//  FakeObject.h
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import Foundation;

@interface FakeObject : NSObject
@property (nonatomic, copy) NSString *observableProperty;
@property (nonatomic, copy) NSString *observableProperty2;
@property (nonatomic, copy) NSString *observableProperty3;
@property (nonatomic, strong) NSMutableArray *observableArray;


@property (nonatomic, assign) NSUInteger calledSomeAction;
- (void)someAction;
@end
