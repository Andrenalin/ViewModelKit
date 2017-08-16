//
//  VMKChooseImageControllerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 07/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKChooseImageController+Private.h"

@interface VMKChooseImageControllerTests : XCTestCase
@property (nonatomic, strong) VMKChooseImageController *sut;

@property (nonatomic, strong) UIViewController *mockViewController;
@property (nonatomic, strong) UIView *mockPopoverView;
@property (nonatomic, assign) CGRect location;
@property (nonatomic, strong) VMKViewModel<VMKChooseImageViewModelType> *mockViewModel;
@property (nonatomic, strong) id<VMKChooseImageControllerDelegate> mockDelegate;

@property (nonatomic, strong) UIImagePickerController *mockImagePickerController;
@end

@implementation VMKChooseImageControllerTests

- (void)setUp {
    [super setUp];
    
    self.mockViewController = mock([UIViewController class]);
    self.mockPopoverView = mock([UIView class]);
    self.location = CGRectMake(10, 12, 25, 20);
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKChooseImageViewModelType));
    self.mockDelegate = mockProtocol(@protocol(VMKChooseImageControllerDelegate));
    
    self.sut = [[VMKChooseImageController alloc] initWithViewController:self.mockViewController inPopoverView:self.mockPopoverView inSourceRect:self.location withViewModel:self.mockViewModel delegate:self.mockDelegate];
    
    self.mockImagePickerController = mock([UIImagePickerController class]);
}

- (void)tearDown {
    self.mockViewController = nil;
    self.mockPopoverView = nil;
    self.mockViewModel = nil;
    stopMocking(self.mockDelegate);
    self.mockDelegate = nil;
    self.mockImagePickerController = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsViewControllerToMock {
    assertThat(self.sut.viewController, is(self.mockViewController));
}

- (void)testInitSetsPopoverViewToMock {
    assertThat(self.sut.popoverView, is(self.mockPopoverView));
}

- (void)testInitSetsLocationToMock {
    assertThatDouble(self.sut.location.origin.x, equalToDouble(10));
    assertThatDouble(self.sut.location.origin.y, equalToDouble(12));
    assertThatDouble(self.sut.location.size.width, equalToDouble(25));
    assertThatDouble(self.sut.location.size.height, equalToDouble(20));
}

- (void)testInitSetsViewModelToMock {
    assertThat(self.sut.viewModel, is(self.mockViewModel));
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

#pragma mark - imagePickerController

- (void)testImagePickerControllerIsNotNil {
    assertThat(self.sut.imagePickerController, notNilValue());
}

- (void)testImagePickerControllerDelegateIsSut {
    assertThat(self.sut.imagePickerController.delegate, is(self.sut));
}

- (void)testImagePickerControllerAllowEditingIsYes {
    assertThatBool(self.sut.imagePickerController.allowsEditing, isTrue());
}

- (void)testImagePickerControllerModalPresentationStyleIsDissolve {
    assertThatInteger(self.sut.imagePickerController.modalPresentationStyle, equalToInteger(UIModalTransitionStyleCrossDissolve));
}

#pragma mark - imagePickerControllerDidCancel 

- (void)testImagePickerControllerDidCancelCallsDismiss {
    self.sut.imagePickerController = self.mockImagePickerController;

    [self.sut imagePickerControllerDidCancel:self.mockImagePickerController];
    
    [verifyCount(self.mockImagePickerController, times(1)) dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - imagePickerController:didFinishPickingMediaWithInfo

- (void)testImagePickerControllerDidFinishPickingMediaWithInfoCallsDismiss {
    self.sut.imagePickerController = self.mockImagePickerController;
    NSDictionary *info = @{};
    
    [self.sut imagePickerController:self.mockImagePickerController didFinishPickingMediaWithInfo:info];
    
    [verifyCount(self.mockImagePickerController, times(1)) dismissViewControllerAnimated:YES completion:nil];
}

- (void)testImagePickerControllerDidFinishPickingMediaWithInfoCallsSetImageEditOnViewModel {
    UIImage *mockImage = mock([UIImage class]);
    NSDictionary *info = @{ UIImagePickerControllerOriginalImage: mockImage};
    
    [self.sut imagePickerController:self.mockImagePickerController didFinishPickingMediaWithInfo:info];
    
    [verifyCount(self.mockViewModel, times(1)) setImageEdit:mockImage];
}

- (void)testImagePickerControllerDidFinishPickingMediaWithInfoCallsSetImageEditWithEditedImage {
    UIImage *mockImage = mock([UIImage class]);
    UIImage *mockEditImage = mock([UIImage class]);
    NSDictionary *info = @{ UIImagePickerControllerOriginalImage: mockImage, UIImagePickerControllerEditedImage: mockEditImage };
    
    [self.sut imagePickerController:self.mockImagePickerController didFinishPickingMediaWithInfo:info];
    
    [verifyCount(self.mockViewModel, times(1)) setImageEdit:mockEditImage];
}

#pragma mark - show

- (void)testShowCallsPresentViewControllerOnViewController {
    self.sut.imagePickerController = self.mockImagePickerController;
    
    [self.sut show];
    
    [verifyCount(self.mockViewController, times(1)) presentViewController:self.mockImagePickerController animated:YES completion:nil];
}

- (void)testShowSetsSourceFromViewModel {
    [given(self.mockViewModel.source) willReturnInteger:UIImagePickerControllerSourceTypePhotoLibrary];
    self.sut.imagePickerController = self.mockImagePickerController;
    
    [self.sut show];
    
    [verifyCount(self.mockImagePickerController, times(1)) setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - dismiss

- (void)testDismissCallsDismissViewControllerAnimatedOnImagePickerController {
    self.sut.imagePickerController = self.mockImagePickerController;
    
    [self.sut dismiss];
    
    [verifyCount(self.mockImagePickerController, times(1)) dismissViewControllerAnimated:YES completion:nil];
}

- (void)testDismissResetImagePickerController {
    self.sut.imagePickerController = self.mockImagePickerController;
    
    [self.sut dismiss];
    
    assertThat(self.sut.imagePickerController, isNot(self.mockImagePickerController));
}

- (void)testDismissCallsDelegateDimissedWithViewModel {
    self.sut.imagePickerController = self.mockImagePickerController;
    
    [self.sut dismiss];
    
    [verifyCount(self.mockDelegate, times(1)) chooseImageController:self.sut dismissedWithViewModel:nil];
}

@end
