//
//  VMKChooseImageAlertViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "FakePasteBoardWithHasImages.h"
#import "FakePasteBoardWithoutHasImage.h"

#import "VMKChooseImageViewModel.h"
#import "VMKChooseImageAlertViewModel+Private.h"

@interface VMKChooseImageAlertViewModelTests : XCTestCase
@property (nonatomic, strong) VMKChooseImageAlertViewModel *sut;

@property (nonatomic, strong) VMKViewModel<VMKImageEditingType> *mockViewModel;
@property (nonatomic, strong) UIImage *mockImage;
@property (nonatomic, strong) UIPasteboard *mockPasteBoard;
@property (nonatomic, strong) FakePasteBoardWithHasImages *fakePasteBoardWithHasImages;
@property (nonatomic, strong) FakePasteBoardWithoutHasImage *fakePasteBoardWithoutHasImages;
@end

@implementation VMKChooseImageAlertViewModelTests

- (void)setUp {
    [super setUp];
    
    self.mockImage = mock([UIImage class]);
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKImageEditingType));
    [given(self.mockViewModel.image) willReturn:self.mockImage];
    self.mockPasteBoard = mock([UIPasteboard class]);
    
    self.fakePasteBoardWithHasImages = [[FakePasteBoardWithHasImages alloc] initWithImage:self.mockImage hasImage:YES];
    self.fakePasteBoardWithoutHasImages = [[FakePasteBoardWithoutHasImage alloc] initWithImage:self.mockImage];

    self.sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:YES showPhotoLibrary:YES showPasteboard:YES pasteboard:self.mockPasteBoard];
}

- (void)tearDown {
    self.mockViewModel = nil;
    self.mockImage = nil;
    self.mockPasteBoard = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsImageViewModelToMock {
    assertThat(self.sut.imageViewModel, is(self.mockViewModel));
}

- (void)testInitSetsShowCameraToYes {
    assertThatBool(self.sut.showCamera, isTrue());
}

- (void)testInitSetsShowPhotoLibraryToYes {
    assertThatBool(self.sut.showPhotoLibrary, isTrue());
}

- (void)testInitSetsShowPasteboardToYes {
    assertThatBool(self.sut.showPasteboard, isTrue());
}

- (void)testInitSetsPasteBoardToMock {
    assertThat(self.sut.pasteBoard, is(self.mockPasteBoard));
}

#pragma mark - title

- (void)testTitleIsEditImage {
    assertThat(self.sut.title, is(@"Edit Image"));
}

#pragma mark - message

- (void)testMessageIsSet {
    assertThat(self.sut.message, is(@"Choose how you would like to edit the image."));
}

#pragma mark - tappedActionWithTitle

- (void)testTappedActionWithTitleDeletePhotoCallsSetImageEditWithNil {
    [self.sut tappedActionWithTitle:@"Delete Photo"];
    
    [verifyCount(self.mockViewModel, times(1)) setImageEdit:nil];
}

- (void)testTappedActionWithTitlePastePhotoCallsSetImageEditWithImage {
    [given(self.mockPasteBoard.image) willReturn:self.mockImage];

    [self.sut tappedActionWithTitle:@"Paste Photo"];

    [verifyCount(self.mockViewModel, times(1)) setImageEdit:self.mockImage];
}

- (void)testTappedActionWithTitleChoosePhotoReturnsViewModelWithSourcePhotoLibrary {
    VMKChooseImageViewModel *viewModel = (VMKChooseImageViewModel *)[self.sut tappedActionWithTitle:@"Choose Photo"];
    
    assertThat(viewModel, notNilValue());
    assertThatInteger(viewModel.source, equalToInteger(UIImagePickerControllerSourceTypePhotoLibrary));
}

- (void)testTappedActionWithTitleTakePhotoReturnsViewModelWithSourceCamera {
    VMKChooseImageViewModel *viewModel = (VMKChooseImageViewModel *)[self.sut tappedActionWithTitle:@"Take Photo"];
    
    assertThat(viewModel, notNilValue());
    assertThatInteger(viewModel.source, equalToInteger(UIImagePickerControllerSourceTypeCamera));
}

#pragma mark - defaultActionTitles

- (void)testDefaultCameraActionTitleIsTakePhoto {
    assertThat([VMKChooseImageAlertViewModel defaultTakePhotoTitle], is(@"Take Photo"));
}

- (void)testDefaultActionTitlesIsEmpty {
    VMKChooseImageAlertViewModel *sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:NO showPhotoLibrary:NO showPasteboard:NO pasteboard:nil];
    
    assertThat(sut.defaultActionTitles, containsIn(@[]));
}

- (void)testDefaultActionTitlesIsPastePhotoWithHasImages {
    VMKChooseImageAlertViewModel *sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:NO showPhotoLibrary:NO showPasteboard:YES pasteboard:(UIPasteboard *)self.fakePasteBoardWithHasImages];
    
    assertThat(sut.defaultActionTitles, containsIn(@[@"Paste Photo"]));
}

- (void)testDefaultActionTitlesIsPastePhotoWithoutHasImages {
    VMKChooseImageAlertViewModel *sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:NO showPhotoLibrary:NO showPasteboard:YES pasteboard:(UIPasteboard *)self.fakePasteBoardWithoutHasImages];
    
    assertThat(sut.defaultActionTitles, containsIn(@[@"Paste Photo"]));
}

- (void)testDefaultActionTitlesIsChoosePhoto {
    VMKChooseImageAlertViewModel *sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:NO showPhotoLibrary:YES showPasteboard:YES pasteboard:self.mockPasteBoard];
    
    assertThat(sut.defaultActionTitles, containsIn(@[@"Choose Photo"]));
}

#pragma mark - destructiveActionTitles

- (void)testDestructiveActionTitlesIsDeletePhoto {
    assertThat(self.sut.destructiveActionTitles, containsIn(@[@"Delete Photo"]));
}

- (void)testDestructiveActionTitlesIsNil {
    [given(self.mockViewModel.image) willReturn:nil];
    VMKChooseImageAlertViewModel *sut = [[VMKChooseImageAlertViewModel alloc] initWithViewModel:self.mockViewModel showCamera:YES showPhotoLibrary:YES showPasteboard:YES pasteboard:self.mockPasteBoard];
    
    assertThat(sut.destructiveActionTitles, nilValue());
}

#pragma mark - cancelActionTitle

- (void)testInitSetsCancelActionTitle {
    assertThat(self.sut.cancelActionTitle, is(@"Cancel"));
}


@end
