//
//  VMKAlertViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKAlertViewModel.h"

@interface VMKAlertViewModelTests : XCTestCase
@property (nonatomic, strong) VMKAlertViewModel *sut;
@end

@implementation VMKAlertViewModelTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKAlertViewModel alloc] initWithTitle:@"title" message:@"message" defaultActionTitles:@[@"defaultT1", @"defaultT2"] destrcutiveActionTitles:@[@"deleteT1", @"deleteT1"] cancelActionTitle:@"cancel" style:VMKAlertViewModelStyleAlert];
}

- (void)tearDown {
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsStyle {
    assertThatUnsignedInteger(self.sut.style, equalToUnsignedInteger(VMKAlertViewModelStyleAlert));
}

- (void)testInitSetsTitle {
    assertThat(self.sut.title, is(@"title"));
}

- (void)testInitSetsMessage {
    assertThat(self.sut.message, is(@"message"));
}

- (void)testInitSetsDefaultActionTitles {
    assertThat(self.sut.defaultActionTitles, containsIn(@[@"defaultT1", @"defaultT2"]));
}

- (void)testInitSetsDestructiveActionTitles {
    assertThat(self.sut.destructiveActionTitles, containsIn(@[@"deleteT1", @"deleteT1"]));
}

- (void)testInitSetsCancelActionTitle {
    assertThat(self.sut.cancelActionTitle, is(@"cancel"));
}

@end
