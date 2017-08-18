//
//  VMKChooseImageViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 08/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKChooseImageViewModel+Private.h"

@interface VMKChooseImageViewModelTests : XCTestCase
@property (nonatomic, strong) VMKChooseImageViewModel *sut;

@property (nonatomic, strong) VMKViewModel<VMKImageEditingType> *mockViewModel;
@end

@implementation VMKChooseImageViewModelTests

- (void)setUp {
    [super setUp];
    
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKImageEditingType));
    self.sut = [[VMKChooseImageViewModel alloc] initWithViewModel:self.mockViewModel source:UIImagePickerControllerSourceTypeCamera];
}

- (void)tearDown {
    self.mockViewModel = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsImageViewModelToMock {
    assertThat(self.sut.model, is(self.mockViewModel));
}

- (void)testInitSetsSourceToTypeCamera {
    assertThatInteger(self.sut.source, equalToInteger(UIImagePickerControllerSourceTypeCamera));
}

#pragma mark - setImageEdit

- (void)testSetImageEditCallsImageEditOnViewModel {
    [self.sut setImageEdit:nil];
    
    [verifyCount(self.mockViewModel, times(1)) setImageEdit:nil];
}

- (void)testSetImageEditCallsImageEditImageOnViewModel {
    UIImage *mockImage = mock([UIImage class]);
    
    [self.sut setImageEdit:mockImage];
    
    [verifyCount(self.mockViewModel, times(1)) setImageEdit:mockImage];
}

@end
