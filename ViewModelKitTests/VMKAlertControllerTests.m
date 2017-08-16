//
//  VMKAlertControllerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 06/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKAlertController+Private.h"

@interface VMKAlertControllerTests : XCTestCase
@property (nonatomic, strong) VMKAlertController *sut;

@property (nonatomic, strong) UIViewController *mockViewController;
@property (nonatomic, strong) UIView *mockPopoverView;
@property (nonatomic, assign) CGRect location;
@property (nonatomic, strong) VMKViewModel<VMKAlertViewModelType> *mockViewModel;
@property (nonatomic, strong) id<VMKAlertControllerDelegate> mockDelegate;

@property (nonatomic, strong) UIAlertController *mockAlertController;
@end

@implementation VMKAlertControllerTests

- (void)setUp {
    [super setUp];
    
    self.mockViewController = mock([UIViewController class]);
    self.mockPopoverView = mock([UIView class]);
    self.location = CGRectMake(10, 12, 25, 20);
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKAlertViewModelType));
    self.mockDelegate = mockProtocol(@protocol(VMKAlertControllerDelegate));
    
    self.sut = [[VMKAlertController alloc] initWithViewController:self.mockViewController inPopoverView:self.mockPopoverView inSourceRect:self.location withViewModel:self.mockViewModel delegate:self.mockDelegate];
    
    self.mockAlertController = mock([UIAlertController class]);
}

- (void)tearDown {
    self.mockViewController = nil;
    self.mockPopoverView = nil;
    self.mockViewModel = nil;
    stopMocking(self.mockDelegate);
    self.mockDelegate = nil;
    self.mockAlertController = nil;
    
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

#pragma mark - alertController

- (void)testAlertControllerIsNotNil {
    assertThat(self.sut.alertController, notNilValue());
}

- (void)testAlertControllerHasSetStyleAlert {
    [given(self.mockViewModel.style) willReturnUnsignedInteger:VMKAlertViewModelStyleAlert];
    
    assertThatUnsignedInteger(self.sut.alertController.preferredStyle, equalToUnsignedInteger(UIAlertControllerStyleAlert));
}

- (void)testAlertControllerHasSetStyleSheet {
    [given(self.mockViewModel.style) willReturnUnsignedInteger:VMKAlertViewModelStyleSheet];
    
    assertThatUnsignedInteger(self.sut.alertController.preferredStyle, equalToUnsignedInteger(UIAlertControllerStyleActionSheet));
}

- (void)testAlertControllerHasTitleFromViewModel {
    [given(self.mockViewModel.title) willReturn:@"viewModelTitle"];
    
    assertThat(self.sut.alertController.title, is(@"viewModelTitle"));
}

- (void)testAlertControllerHasMessageFromViewModel {
    [given(self.mockViewModel.message) willReturn:@"viewModelMessage"];
    
    assertThat(self.sut.alertController.message, is(@"viewModelMessage"));
}

- (void)testAlertControllerPreferredStyleIsActionSheet {
    assertThatUnsignedInteger(self.sut.alertController.preferredStyle, equalToUnsignedInteger(UIAlertControllerStyleActionSheet));
}

#pragma mark - actions

- (void)testAlertControllerDefaultActions {
    NSArray *titles = @[ @"1", @"2" ];
    [given(self.mockViewModel.defaultActionTitles) willReturn:titles];
    
    assertThat(self.sut.alertController.actions, hasCountOf(2));
    
    for (NSUInteger i = 0; i < 2; ++i) {
        assertThatUnsignedInteger(self.sut.alertController.actions[i].style, equalToUnsignedInteger(UIAlertActionStyleDefault));
        
        assertThat(self.sut.alertController.actions[i].title, is(titles[i]));
    }
}

- (void)testAlertControllerDestructiveActions {
    NSArray *titles = @[ @"d1", @"d2" ];
    [given(self.mockViewModel.destructiveActionTitles) willReturn:titles];
    
    assertThat(self.sut.alertController.actions, hasCountOf(2));
    
    for (NSUInteger i = 0; i < 2; ++i) {
        assertThatUnsignedInteger(self.sut.alertController.actions[i].style, equalToUnsignedInteger(UIAlertActionStyleDestructive));
        
        assertThat(self.sut.alertController.actions[i].title, is(titles[i]));
    }
}

- (void)testAlertControllerCancel {
    [given(self.mockViewModel.cancelActionTitle) willReturn:@"cancel"];
    
    assertThat(self.sut.alertController.actions, hasCountOf(1));
    assertThatUnsignedInteger(self.sut.alertController.actions[0].style, equalToUnsignedInteger(UIAlertActionStyleCancel));
    
    assertThat(self.sut.alertController.actions[0].title, is(@"cancel"));
}

#pragma mark - show

- (void)testShowCallsPresentViewControllerOnViewController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut show];
    
    [verifyCount(self.mockViewController, times(1)) presentViewController:self.mockAlertController animated:YES completion:nil];
}

#pragma mark - dismiss

- (void)testDismissCallsDismissViewControllerAnimatedOnViewController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut dismiss];
    
    [verifyCount(self.mockAlertController, times(1)) dismissViewControllerAnimated:YES completion:nil];
}

- (void)testDismissCallsDelegateAlertControllerDismissedWithViewModel {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut dismiss];
    
    [verifyCount(self.mockDelegate, times(1)) alertController:self.sut dismissedWithViewModel:nil];
}

- (void)testDismissResetAlertController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut dismiss];
    
    assertThat(self.sut.alertController, isNot(self.mockAlertController));
}

#pragma mark - handleActionWithTitle:

- (void)testHandleActionWithTitleCallsDelegate {
    VMKViewModel *mockNextViewModel = mock([VMKViewModel class]);
    [given([self.mockViewModel tappedActionWithTitle:@"test"]) willReturn:mockNextViewModel];
    
    [self.sut handleActionWithTitle:@"test"];
    
    [verifyCount(self.mockDelegate, times(1)) alertController:self.sut dismissedWithViewModel:mockNextViewModel];
}

- (void)testHandleActionWithTitleResetAlertController {
    self.sut.alertController = self.mockAlertController;
    
    [self.sut handleActionWithTitle:@"test"];
    
    assertThat(self.sut.alertController, isNot(self.mockAlertController));
}

@end
