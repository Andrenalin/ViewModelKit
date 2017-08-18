//
//  VMKViewControllerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKViewController.h"
#import "VMKViewModel.h"
#import "VMKControllerModel.h"
#import "VMKBindingUpdater.h"
#import "FakeViewController.h"


@interface VMKViewControllerTests : XCTestCase
@property (nonatomic, strong) VMKViewController *sut;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@property (nonatomic, strong) VMKControllerModel *mockControllerModel;
@property (nonatomic, strong) FakeViewController *fakeViewController;

@property (nonatomic, strong) UIView *mockView;
@property (nonatomic, strong) VMKAlertController *mockAlertController;
@property (nonatomic, strong) VMKChooseImageController *mockChooseImageController;
@property (nonatomic, strong) VMKViewModel<VMKAlertViewModelType> *mockAlertViewModel;
@property (nonatomic, strong) VMKViewModel<VMKChooseImageViewModelType> *mockChooseImageViewModel;
@end

@implementation VMKViewControllerTests

- (void)setUp {
    [super setUp];
    self.sut = [[VMKViewController alloc] init];
    self.mockViewModel = mock([VMKViewModel class]);
    self.sut.viewModel = self.mockViewModel;
    self.mockControllerModel = mock([VMKControllerModel class]);
    self.sut.controllerModel = self.mockControllerModel;
    
    self.fakeViewController = [[FakeViewController alloc] init];
    self.fakeViewController.viewModel = self.mockViewModel;
    
    self.mockView = mock([UIView class]);
    self.mockAlertController = mock([VMKAlertController class]);
    self.mockChooseImageController = mock([VMKChooseImageController class]);
    self.mockAlertViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKAlertViewModelType));
    self.mockChooseImageViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKChooseImageViewModelType));
}

- (void)tearDown {
    stopMocking(self.mockControllerModel);
    stopMocking(self.mockViewModel);
    
    self.mockChooseImageViewModel = nil;
    self.mockAlertViewModel = nil;
    self.mockChooseImageController = nil;
    self.mockAlertController = nil;
    self.mockView = nil;
    self.fakeViewController = nil;
    self.mockControllerModel = nil;
    self.mockViewModel = nil;
    
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsViewModelToMock {
    assertThat(self.sut.viewModel, is(self.mockViewModel));
}

- (void)testInitSetsControllerModelToMock {
    assertThat(self.sut.controllerModel, is(self.mockControllerModel));
}

#pragma mark - viewWillAppear:

- (void)testViewWillAppearDoesNotCallBindBindingDictionaryOnViewModel {
    
    [self.sut viewWillAppear:NO];
    [verifyCount(self.mockViewModel, never()) bindBindingDictionary:anything()];
}

#pragma mark - viewWillDisappear:

- (void)testViewWillDisappearCallsUnbindObserver {
    
    [self.sut viewWillDisappear:NO];
    [verifyCount(self.mockViewModel, times(1)) unbindObserver:self.sut];
}

#pragma mark - bindingUpdaterOnSelector:

- (void)testBindingUpdaterOnSelectorReturnsBindingUpdaterWithSutAsObserver {
    
    VMKBindingUpdater *result = [self.sut bindingUpdaterOnSelector:@selector(viewModel)];
    assertThatBool([result isObserver:self.sut], isTrue());
}

#pragma mark - setEditing:animated:

- (void)testSetEditingYesAnimatedSetsYesOnControllerModel {
    
    [self.sut setEditing:YES animated:NO];
    [verifyCount(self.mockControllerModel, times(1)) setEditing:YES];
}

- (void)testSetEditingNoAnimatedSetsNoOnControllerModel {
    
    [self.sut setEditing:NO animated:NO];
    [verifyCount(self.mockControllerModel, times(1)) setEditing:NO];
}

- (void)testSetEditingYesSetsYesOnControllerModel {
    
    [self.sut setEditing:YES];
    [verifyCount(self.mockControllerModel, times(1)) setEditing:YES];
}

#pragma mark - presentControllerWithViewModel:inView:

- (void)testPresentControllerWithViewModelNilInViewNilDoesNotCreateAnyController {
    [self.sut presentControllerWithViewModel:nil inView:nil];
    
    assertThat(self.sut.alertController, nilValue());
    assertThat(self.sut.chooseImageController, nilValue());
}

- (void)testPresentControllerWithViewModelAlertTypeInViewCreateAlertController {
    [self.sut presentControllerWithViewModel:self.mockAlertViewModel inView:self.mockView];
    
    assertThat(self.sut.alertController, notNilValue());
    assertThat(self.sut.alertController.popoverView, is(self.mockView));
    assertThat(self.sut.chooseImageController, nilValue());
}

- (void)testPresentControllerWithViewModelAlertTypeInViewNilUseSelfView {
    [self.sut presentControllerWithViewModel:self.mockAlertViewModel inView:nil];
    
    assertThat(self.sut.alertController, notNilValue());
    assertThat(self.sut.alertController.popoverView, notNilValue());
}

- (void)testPresentControllerWithViewModelChooseImageTypeInViewCreateChooseImageController {
    [self.sut presentControllerWithViewModel:self.mockChooseImageViewModel inView:self.mockView];
    
    assertThat(self.sut.alertController, nilValue());
    assertThat(self.sut.chooseImageController, notNilValue());
    assertThat(self.sut.chooseImageController.popoverView, is(self.mockView));
}

#pragma mark - alertController:dismissedWithViewModel:

- (void)testAlertControllerDismissedWithViewModelResetsAlertController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut alertController:self.mockAlertController dismissedWithViewModel:nil];
    
    assertThat(self.sut.alertController, nilValue());
}

- (void)testAlertControllerDismissedWithViewModelResetAlertController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut alertController:self.mockAlertController dismissedWithViewModel:self.mockAlertViewModel];
    
    assertThat(self.sut.alertController, notNilValue());
}

#pragma mark - chooseImageController:dismissedWithViewModel:

- (void)testChooseImageControllerDismissedWithViewModelResetsAlertController {
    self.sut.chooseImageController = self.mockChooseImageController;
    
    [self.sut chooseImageController:self.mockChooseImageController dismissedWithViewModel:nil];
    
    assertThat(self.sut.chooseImageController, nilValue());
}

- (void)testChooseImageControllerDismissedWithViewModelResetAlertController {
    self.sut.chooseImageController = self.mockChooseImageController;
    
    [self.sut chooseImageController:self.mockChooseImageController dismissedWithViewModel:self.mockChooseImageViewModel];
    
    assertThat(self.sut.chooseImageController, notNilValue());
}

#pragma mark - FakeViewController

- (void)testViewWillAppearCallsBinBindingDictionary {

    VMKBindingDictionary *dict = [self.fakeViewController viewModelBindings];
    [self.fakeViewController viewWillAppear:NO];
    
    [verifyCount(self.mockViewModel, times(1)) bindBindingDictionary:dict];
}

@end
