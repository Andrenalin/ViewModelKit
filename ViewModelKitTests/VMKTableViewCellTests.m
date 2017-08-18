//
//  VMKTableViewCellTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKTableViewCell.h"

@interface VMKTableViewCellTests : XCTestCase
@property (nonatomic, strong) VMKTableViewCell *sut;

@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModel;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockViewModelNew;
@end

@implementation VMKTableViewCellTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TestCell"];
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.mockViewModelNew = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
}

- (void)tearDown {
    stopMocking(self.mockViewModel);
    stopMocking(self.mockViewModelNew);

    self.mockViewModel = nil;
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
    assertThatBool([VMKTableViewCell automaticallyNotifiesObserversForKey:@"viewModel"], isFalse());
}

#pragma mark - reuseIdentifier

- (void)testReuseIdentifierIsClassName {
    assertThat([VMKTableViewCell reuseIdentifier], is(@"VMKTableViewCell"));
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

#pragma mark - titleDidChange

- (void)testTitleDidChangeSetsTextOnTextLabel {
    [given([self.mockViewModel title]) willReturn:@"title"];
    self.sut.viewModel = self.mockViewModel;
    
    [self.sut titleDidChange];
    
    assertThat(self.sut.textLabel.text, is(@"title"));
}

#pragma mark - subtitleDidChange

- (void)testSubtitleDidChangeSetsTextOnDetailTextLabel {
    [given([self.mockViewModel subtitle]) willReturn:@"subtitle"];
    self.sut.viewModel = self.mockViewModel;
    
    [self.sut subtitleDidChange];
    
    assertThat(self.sut.detailTextLabel.text, is(@"subtitle"));
}

#pragma mark - imageDidChange

- (void)testImageDidChangeSetsImageOnImageView {
    UIImage *mockImage = mock([UIImage class]);
    [given([self.mockViewModel image]) willReturn:mockImage];
    self.sut.viewModel = self.mockViewModel;
    
    [self.sut imageDidChange];
    
    assertThat(self.sut.imageView.image, is(mockImage));
}

#pragma mark - willMoveToSuperview

- (void)testWillMoveToSuperviewCallsUnbindObserverOnViewModel {
    self.sut.viewModel = self.mockViewModel;
    
    [self.sut willMoveToSuperview:nil];
    
    [verifyCount(self.mockViewModel, times(1)) unbindObserver:self.sut];
}

@end
