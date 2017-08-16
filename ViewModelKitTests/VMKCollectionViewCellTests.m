//
//  VMKCollectionViewCellTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 27/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKCollectionViewCell.h"

@interface VMKCollectionViewCellTests : XCTestCase
@property (nonatomic, strong) VMKCollectionViewCell *sut;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModel;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModelNew;
@end

@implementation VMKCollectionViewCellTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKCollectionViewCell alloc] init];
    
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.mockViewModelNew = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
}

- (void)tearDown {
    stopMocking(self.mockViewModel);
    self.mockViewModel = nil;
    stopMocking(self.mockViewModelNew);
    self.mockViewModelNew = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsViewModelToNil {
    assertThat(self.sut.viewModel, nilValue());
}

#pragma mark - automaticallyNotifiesObserversOfViewModel

- (void)testAutomaticallyNotifiesObserversOfViewModelReturnsNo {
    assertThatBool([VMKCollectionViewCell automaticallyNotifiesObserversForKey:@"viewModel"], isFalse());
}

#pragma mark - reuseIdentifier

- (void)testReuseIdentifierIsClassName {
    assertThat([VMKCollectionViewCell reuseIdentifier], is(@"VMKCollectionViewCell"));
}

#pragma mark - setViewModel

- (void)testSetViewModelCallsBindBindingDictionaryOnViewModel {
    [self.sut setValue:@YES forKey:@"observingAllowed"];

    self.sut.viewModel = self.mockViewModel;
    
    [[verifyCount(self.mockViewModel, times(1)) withMatcher:anything() forArgument:0] bindBindingDictionary:anything()];
}

- (void)testSetViewModelTwiceWithSameObjectCallsOnylOnceBindBindingDictionary {
    [self.sut setValue:@YES forKey:@"observingAllowed"];
    self.sut.viewModel = self.mockViewModel;
    
    self.sut.viewModel = self.mockViewModel;
    
    [[verifyCount(self.mockViewModel, times(1)) withMatcher:anything() forArgument:0] bindBindingDictionary:anything()];
}

- (void)testSetViewModelCallsUnbindObserverOnPreviousViewModel {
    self.sut.viewModel = self.mockViewModel;
    
    self.sut.viewModel = self.mockViewModelNew;
    
    [verifyCount(self.mockViewModel, times(1)) unbindObserver:self.sut];
}

#pragma mark - bindingUpdaterOnSelector:

- (void)testBindingUpdaterOnSelectorReturnsNotNil {
    assertThat([self.sut bindingUpdaterOnSelector:@selector(setViewModel:)], notNilValue());
}

#pragma mark - willMoveToSuperview

- (void)testWillMoveToSuperviewCallsUnbindObserverOnViewModel {
    self.sut.viewModel = self.mockViewModel;
    
    [self.sut willMoveToSuperview:nil];
    
    [verifyCount(self.mockViewModel, times(1)) unbindObserver:self.sut];
}

@end
