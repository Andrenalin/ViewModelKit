//
//  VMKTableViewControllerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 27/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKViewModel.h"
#import "VMKControllerModel.h"
#import "VMKTableViewController.h"
#import "VMKDataSource.h"
#import "VMKTableViewDataSource.h"
#import "VMKViewCellType.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"
#import "FakeTableView.h"

@interface VMKTableViewControllerTests : XCTestCase
@property (nonatomic, strong) VMKTableViewController *sut;

@property (nonatomic, strong) VMKViewModel<VMKDataSourceViewModelType> *mockViewModel;
@property (nonatomic, strong) VMKControllerModel *mockControllerModel;

@property (nonatomic, strong) UIView *mockView;
@property (nonatomic, strong) VMKAlertController *mockAlertController;
@property (nonatomic, strong) VMKChooseImageController *mockChooseImageController;
@property (nonatomic, strong) VMKViewModel<VMKAlertViewModelType> *mockAlertViewModel;
@property (nonatomic, strong) VMKViewModel<VMKChooseImageViewModelType> *mockChooseImageViewModel;

@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) VMKTableViewDataSource *mockTableViewDataSource;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) UITableViewCell<VMKViewCellType> *mockTableViewCell;
@property (nonatomic, strong) FakeTableView *fakeTableView;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockCellViewModel;
@property (nonatomic, strong) VMKViewModel<VMKHeaderFooterType> *mockHeaderViewModel;

@property (nonatomic, strong) VMKChangeSet *mockChangeSet;
@property (nonatomic, strong) VMKSingleChange *mockSingleChange;
@end


@implementation VMKTableViewControllerTests

- (void)setUp {
    [super setUp];

    self.sut = [[VMKTableViewController alloc] init];
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKDataSourceViewModelType));
    self.sut.viewModel = self.mockViewModel;
    self.mockControllerModel = mock([VMKControllerModel class]);
    self.sut.controllerModel = self.mockControllerModel;
    
    self.mockView = mock([UIView class]);
    self.mockAlertController = mock([VMKAlertController class]);
    self.mockChooseImageController = mock([VMKChooseImageController class]);
    self.mockAlertViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKAlertViewModelType));
    self.mockChooseImageViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKChooseImageViewModelType));
    
    self.mockDataSource = mock([VMKDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:self.mockDataSource];
    self.mockTableViewDataSource = mock([VMKTableViewDataSource class]);
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockTableViewCell = mockObjectAndProtocol([UITableViewCell class], @protocol(VMKViewCellType));
    self.fakeTableView = [[FakeTableView alloc] init];
    self.mockCellViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.mockHeaderViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKHeaderFooterType));
    
    self.mockChangeSet = mock([VMKChangeSet class]);
    self.mockSingleChange = mock([VMKSingleChange class]);
}

- (void)tearDown {
    
    stopMocking(self.mockViewModel);
    stopMocking(self.mockControllerModel);
    
    stopMocking(self.mockView);
    stopMocking(self.mockAlertController);
    stopMocking(self.mockChooseImageController);
    stopMocking(self.mockAlertViewModel);
    stopMocking(self.mockChooseImageViewModel);

    stopMocking(self.mockDataSource);
    stopMocking(self.mockTableViewDataSource);

    stopMocking(self.mockTableViewCell);
    stopMocking(self.mockCellViewModel);
    stopMocking(self.mockHeaderViewModel);
    
    stopMocking(self.mockChangeSet);
    stopMocking(self.mockSingleChange);
    
    self.mockControllerModel = nil;
    self.mockViewModel = nil;
    
    self.mockView = nil;
    self.mockAlertController = nil;
    self.mockChooseImageController = nil;
    self.mockAlertViewModel = nil;
    self.mockChooseImageViewModel = nil;

    self.mockDataSource = nil;
    self.mockTableViewDataSource = nil;
    
    self.mockIndexPath = nil;
    self.mockTableViewCell = nil;
    self.fakeTableView = nil;
    self.mockCellViewModel = nil;
    self.mockHeaderViewModel = nil;
    
    self.mockChangeSet = nil;
    self.mockSingleChange = nil;
    
    self.sut = nil;
    
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsViewModel {
    assertThat(self.sut.viewModel, is(self.mockViewModel));
}

- (void)testInitSetsControllerModel {
    assertThat(self.sut.controllerModel, is(self.mockControllerModel));
}

#pragma mark - viewWillAppear:

- (void)testViewWillAppearDoesNotCallBindBindingDictionaryOnViewModel {
    [given([self.mockViewModel dataSource]) willReturn:nil];
    
    [self.sut viewWillAppear:NO];
    [verifyCount(self.mockViewModel, never()) bindBindingDictionary:anything()];
}

#pragma mark - viewWillDisappear:

- (void)testViewWillDisappearCallsUnbindObserver {
    
    [self.sut viewWillDisappear:NO];
    [verifyCount(self.mockViewModel, times(1)) unbindObserver:self.sut];
}

#pragma mark - dataSourceDidChange

- (void)testdataSourceDidChangeReturnsTrue {
    assertThatBool([self.sut dataSourceDidChange], isFalse());
    VMKDataSource *mockNewDataSource = mock([VMKDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:mockNewDataSource];
    
    assertThatBool([self.sut dataSourceDidChange], isTrue());
}

- (void)testdataSourceDidChangeSetsNewDataSource {
    id oldDataSource = self.sut.tableView.dataSource ;
    [self.sut dataSourceDidChange];
    VMKDataSource *mockNewDataSource = mock([VMKDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:mockNewDataSource];
    
    [self.sut dataSourceDidChange];
    
    assertThat(self.sut.tableView.dataSource, isNot(oldDataSource));

}

#pragma mark - prepareForSegue:

//- (void)testPrepareForSegueCallsTopViewController {
//    self.fakeTableView.indexPathForSelectedRowReturn = self.mockIndexPath;
//    self.sut.tableView = self.fakeTableView;
//    
//    UIViewController<VMKViewModelControllerType> *mockViewController = mockObjectAndProtocol([UIViewController class], @protocol(VMKViewModelControllerType));
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mockViewController];
//    UIStoryboardSegue *mockSegue = mock([UIStoryboardSegue class]);
//    [given(mockSegue.destinationViewController) willReturn:navVC];
//        
//    [self.sut prepareForSegue:mockSegue sender:self];
//    
//    [(id<VMKViewModelControllerType>)verifyCount(mockViewController, times(1)) setViewModel:anything()];
//}
//
//- (void)testPrepareForSegueSetsViewModelOnDestinationController {
//    id<VMKViewModelControllerType> mockViewController = mockProtocol(@protocol(VMKViewModelControllerType));
//    UIStoryboardSegue *mockSegue = mock([UIStoryboardSegue class]);
//    [given(mockSegue.destinationViewController) willReturn:mockViewController];
//    
//    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
////    [self.sut.tableView selectRowAtIndexPath:first animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [given([self.mockDataSource viewModelAtIndexPath:first]) willReturn:self.mockCellViewModel];
//    [given(self.mockCellViewModel.viewModel) willReturn:self.mockChooseImageViewModel];
//    
//    [self.sut prepareForSegue:mockSegue sender:self];
//    
//    [(id<VMKViewModelControllerType>)verifyCount(mockViewController, times(1)) setViewModel:self.mockChooseImageViewModel];
//    [verifyCount(self.mockControllerModel, times(1)) controllerModelForSegue:mockSegue];
//}

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

- (void)testSetEditingYesSetsYesOnDataSourceFrom {
    [self.sut setEditing:YES];
    
    [verifyCount(self.mockDataSource, times(1)) setEditing:YES];
}

#pragma mark - tableView:didSelectRowAtIndexPath:

- (void)testTableViewDidSelectRowAtIndexPathSetsSelectedIndexPath {
    self.sut.selectedIndexPath = nil;
    
    [self.sut tableView:self.fakeTableView didSelectRowAtIndexPath:self.mockIndexPath];
    
    assertThat(self.sut.selectedIndexPath, is(self.mockIndexPath));
}

#pragma mark - tableView:didDeselectRowAtIndexPath:

- (void)testTableViewDidDeselectRowAtIndexPathSetsSelectedIndexPath {
    self.sut.selectedIndexPath = self.mockIndexPath;
    
    [self.sut tableView:self.fakeTableView didDeselectRowAtIndexPath:self.mockIndexPath];
    
    assertThat(self.sut.selectedIndexPath, nilValue());
}

#pragma mark - dataSource:cellIdentifierAtIndexPath:

- (void)testDataSourceCellIdentifierAtIndexPathReturnsCell {
    assertThat([self.sut dataSource:self.mockTableViewDataSource cellIdentifierAtIndexPath:self.mockIndexPath], is(@"Cell"));
}

#pragma mark - dataSource:configureCell:

- (void)testDataSourceConfigureCellSetsViewModel {
    [self.sut dataSource:self.mockTableViewDataSource configureCell:self.mockTableViewCell withViewModel:self.mockCellViewModel];
    
    [(id<VMKViewCellType>)verifyCount(self.mockTableViewCell, times(1)) setViewModel:self.mockCellViewModel];
}

- (void)testDataSourceConfigureCellNotThrowIfProtocolIsNotImplemented {
    UITableViewCell *mockCell = mock([UITableViewCell class]);

    XCTAssertNoThrow([self.sut dataSource:self.mockTableViewDataSource configureCell:mockCell withViewModel:self.mockCellViewModel]);
}

#pragma mark - dataSource:didChangeWithChangeSet:

- (void)testDataSourceDidChangeWithChangeSetCallsUpdatesOnTableView {
    self.sut.tableView = self.fakeTableView;
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.beginUpdatesCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.endUpdatesCalled, equalToInteger(1));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionChanged {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionChanged sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.reloadSectionsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.reloadSectionsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.reloadSectionsWithRowAnimationSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionInserted {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionInserted sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.insertSectionsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.insertSectionsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.insertSectionsWithRowAnimationSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionDeleted {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionDeleted sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.deleteSectionsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.deleteSectionsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.deleteSectionsWithRowAnimationSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowChanged {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowChanged rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.reloadRowsAtIndexPathsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.reloadRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.reloadRowsAtIndexPathsWithRowAnimationIndexPathsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowInserted {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowInserted rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationIndexPathsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowDeleted {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowDeleted rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationIndexPathsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowMoved {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    NSArray<NSIndexPath *> *rowsToMove = @[[NSIndexPath indexPathForRow:1 inSection:23]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowMoved rows:rows movedToRows:rowsToMove];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.deleteRowsAtIndexPathsWithRowAnimationIndexPathsParameter, is(rows));

    assertThatInteger(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationCalled, equalToInteger(1));
    assertThatInteger(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationTableViewRowAnimationParameter, equalToInteger(UITableViewRowAnimationAutomatic));
    assertThat(self.fakeTableView.insertRowsAtIndexPathsWithRowAnimationIndexPathsParameter, is(rowsToMove));
}

- (void)testDataSourceDidChangeWithChangeSetWithSeletcedIndexPath {
    self.fakeTableView.indexPathForSelectedRowReturn = self.mockIndexPath;
    self.sut.tableView = self.fakeTableView;
    [given([self.mockChangeSet changedIndexPathForPreviousIndexPath:self.mockIndexPath]) willReturn:self.mockIndexPath];
    
    [self.sut dataSource:self.mockTableViewDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeTableView.selectRowAtIndexPathAnimatedSrcollPositionCalled, equalToInteger(1));
    assertThatBool(self.fakeTableView.selectRowAtIndexPathAnimatedSrcollPositionAnimatedParameter, isTrue());
    assertThatInteger(self.fakeTableView.selectRowAtIndexPathAnimatedSrcollPositionTableViewScrollPositionParameter, equalToInteger(UITableViewScrollPositionMiddle));
    assertThat(self.fakeTableView.selectRowAtIndexPathAnimatedSrcollPositionIndexPathParameter, is(self.mockIndexPath));    
}

#pragma mark - dataSource:headerCellIdentifierAtSection:

- (void)testDataSourceHeaderCellIdentifierAtSectionPathReturnsCell {
    assertThat([self.sut dataSource:self.mockTableViewDataSource headerViewIdentifierAtSection:42], is(@"SectionCell"));
}

#pragma mark - dataSource:configureHeaderView:

- (void)testDataSourceConfigureHeaderViewSetsViewModel {
    UITableViewHeaderFooterView<VMKViewHeaderFooterType> *mockCell = mockObjectAndProtocol([UITableViewHeaderFooterView class], @protocol(VMKViewHeaderFooterType));

    [self.sut dataSource:self.mockTableViewDataSource configureHeaderView:mockCell withViewModel:self.mockHeaderViewModel];
    
    [(id<VMKViewHeaderFooterType>)verifyCount(mockCell, times(1)) setViewModel:self.mockHeaderViewModel];
}

- (void)testDataSourceConfigureHeaderViewNotThrowIfProtocolIsNotImplemented {
    UITableViewHeaderFooterView *mockCell = mock([UITableViewHeaderFooterView class]);
    
    XCTAssertNoThrow([self.sut dataSource:self.mockTableViewDataSource configureHeaderView:mockCell withViewModel:self.mockHeaderViewModel]);
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

#pragma mark - requestViewWithViewModel:atIndexPath:

- (void)testRequestViewWithViewModelAtIndexPath {
    [self.sut requestViewWithViewModel:self.mockAlertViewModel atIndexPath:self.mockIndexPath];
    
    assertThat(self.sut.alertController, notNilValue());
    assertThat(self.sut.alertController.popoverView, is(self.sut.view));
}

#pragma mark - helpers 

- (void)setupChangeSetWithType:(VMKSingleChangeType)type sectionSet:(NSIndexSet *)indexSet {
    self.sut.tableView = self.fakeTableView;
    
    [given(self.mockChangeSet.history) willReturn:@[self.mockSingleChange]];
    [given(self.self.mockSingleChange.type) willReturnUnsignedInteger:type];
    [given(self.mockSingleChange.sectionSet) willReturn:indexSet];
}

- (void)setupChangeSetWithType:(VMKSingleChangeType)type rows:(NSArray<NSIndexPath *> *)rows movedToRows:(NSArray<NSIndexPath *> *)movedToRows {
    
    self.sut.tableView = self.fakeTableView;
    
    [given(self.mockChangeSet.history) willReturn:@[self.mockSingleChange]];
    [given(self.self.mockSingleChange.type) willReturnUnsignedInteger:type];
    [given(self.mockSingleChange.rows) willReturn:rows];
    [given(self.mockSingleChange.movedToRows) willReturn:movedToRows];
}

@end
