//
//  VMKTableViewRowActionViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKTableViewRowActionViewModel.h"

@interface VMKTableViewRowActionViewModelTests : XCTestCase
@property (nonatomic, strong) VMKTableViewRowActionViewModel *sut;

@property (nonatomic, strong) UIColor *mockColor;
@property (nonatomic, strong) id<VMKTableViewRowActionViewModelDelegate> mockDelegate;
@end

@implementation VMKTableViewRowActionViewModelTests

- (void)setUp {
    [super setUp];

    self.mockColor = mock([UIColor class]);
    self.mockDelegate = mockProtocol(@protocol(VMKTableViewRowActionViewModelDelegate));
    
    self.sut = [[VMKTableViewRowActionViewModel alloc] initWithTitle:@"testTitle" style:VMKTableViewRowActionViewModelStyleNormal backgroundColor:self.mockColor delegate:self.mockDelegate];
}

- (void)tearDown {
    self.mockColor = nil;
    self.mockDelegate = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsTitleToTestTitle {
    assertThat(self.sut.title, is(@"testTitle"));
}

- (void)testInitSetsStyleToNormal {
    assertThatUnsignedInteger(self.sut.style, equalToUnsignedInteger(VMKTableViewRowActionViewModelStyleNormal));
}

- (void)testInitSetsBackgroundColorToMock {
    assertThat(self.sut.backgroundColor, is(self.mockColor));
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

#pragma mark - initWithTitle:style:backgroundColor:delegate:

- (void)testInitWithTitleNilStyleDestructiveBackgroundColorNilDelegateNil {
    VMKTableViewRowActionViewModel *sut = [[VMKTableViewRowActionViewModel alloc] initWithTitle:nil style:VMKTableViewRowActionViewModelStyleDestructive backgroundColor:nil delegate:nil];
    
    assertThat(sut.title, nilValue());
    assertThatUnsignedInteger(sut.style, equalToUnsignedInteger(VMKTableViewRowActionViewModelStyleDestructive));
    assertThat(sut.backgroundColor, nilValue());
    assertThat(sut.delegate, nilValue());
}

#pragma mark - swipedRowActionAtIndexPath:

- (void)testSwipedRowActionAtIndexPathReturnsViewModel {
    NSIndexPath *mockIndexPath = mock([NSIndexPath class]);
    VMKViewModel *mockViewModel = mock([VMKViewModel class]);
    [given([self.mockDelegate tableViewRowActionViewModel:self.sut rowActionIndexPath:mockIndexPath]) willReturn:mockViewModel];
    
    assertThat([self.sut swipedRowActionAtIndexPath:mockIndexPath], is(mockViewModel));
}

@end
