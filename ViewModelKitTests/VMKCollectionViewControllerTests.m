//
//  VMKCollectionViewControllerTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 27/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKViewModel.h"
#import "VMKControllerModel.h"
#import "VMKCollectionViewDataSource.h"
#import "VMKViewCellType.h"

#import "VMKCollectionViewController.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"
#import "FakeCollectionView.h"


@interface VMKCollectionViewControllerTests : XCTestCase
@property (nonatomic, strong) VMKCollectionViewController *sut;

@property (nonatomic, strong) VMKViewModel<VMKDataSourceViewModelType> *mockViewModel;
@property (nonatomic, strong) VMKControllerModel *mockControllerModel;
@property (nonatomic, strong) VMKCollectionViewDataSource *mockDataSource;

@property (nonatomic, strong) UIView *mockView;
@property (nonatomic, strong) VMKAlertController *mockAlertController;
@property (nonatomic, strong) VMKChooseImageController *mockChooseImageController;
@property (nonatomic, strong) VMKViewModel<VMKAlertViewModelType> *mockAlertViewModel;
@property (nonatomic, strong) VMKViewModel<VMKChooseImageViewModelType> *mockChooseImageViewModel;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) UICollectionViewCell *mockCollectionViewCell;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockCellViewModel;
@property (nonatomic, strong) FakeCollectionView *fakeCollectionView;
@property (nonatomic, strong) VMKChangeSet *mockChangeSet;
@property (nonatomic, strong) VMKSingleChange *mockSingleChange;
@end

@implementation VMKCollectionViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    
    self.mockViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKDataSourceViewModelType));
    self.sut.viewModel = self.mockViewModel;
    self.mockControllerModel = mock([VMKControllerModel class]);
    self.sut.controllerModel = self.mockControllerModel;
    
    self.mockView = mock([UIView class]);
    self.mockAlertController = mock([VMKAlertController class]);
    self.mockChooseImageController = mock([VMKChooseImageController class]);
    self.mockAlertViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKAlertViewModelType));
    self.mockChooseImageViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKChooseImageViewModelType));
    
    self.mockDataSource = mock([VMKCollectionViewDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:self.mockDataSource];
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockCollectionViewCell = mock([UICollectionViewCell class]);
    self.mockCellViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    self.fakeCollectionView = [[FakeCollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 128) collectionViewLayout:[[UICollectionViewLayout alloc] init]];
    self.mockChangeSet = mock([VMKChangeSet class]);
    self.mockSingleChange = mock([VMKSingleChange class]);
}

- (void)tearDown {
    stopMocking(self.mockControllerModel);
    stopMocking(self.mockViewModel);
    stopMocking(self.mockChangeSet);
    stopMocking(self.mockSingleChange);
    
    self.mockViewModel = nil;
    self.mockControllerModel = nil;
    self.mockDataSource = nil;
 
    self.mockView = nil;
    self.mockAlertController = nil;
    self.mockChooseImageController = nil;
    self.mockAlertViewModel = nil;
    self.mockChooseImageViewModel = nil;
    self.mockIndexPath = nil;
    self.mockCollectionViewCell = nil;
    self.mockCellViewModel = nil;
    self.fakeCollectionView = nil;
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

#pragma mark - bindingUpdaterOnSelector:

- (void)testBindingUpdaterOnSelectorReturnsBindingUpdaterWithSutAsObserver {
    
    VMKBindingUpdater *result = [self.sut bindingUpdaterOnSelector:@selector(viewModel)];
    assertThatBool([result isObserver:self.sut], isTrue());
}

#pragma mark - dataSourceDidChange

- (void)testdataSourceDidChangeReturnsTrue {
    assertThatBool([self.sut dataSourceDidChange], isFalse());
    VMKDataSource *mockNewDataSource = mock([VMKDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:mockNewDataSource];
    
    assertThatBool([self.sut dataSourceDidChange], isTrue());
}

- (void)testdataSourceDidChangeSetsNewDataSource {
    id oldDataSource = self.sut.collectionView.dataSource ;
    [self.sut dataSourceDidChange];
    VMKDataSource *mockNewDataSource = mock([VMKDataSource class]);
    [given(self.mockViewModel.dataSource) willReturn:mockNewDataSource];
    
    [self.sut dataSourceDidChange];
    
    assertThat(self.sut.collectionView.dataSource, isNot(oldDataSource));
}

#pragma mark - prepareForSegue:

//- (void)testPrepareForSegueCallsTopViewController {
//    
//    UIViewController<VMKViewModelControllerType> *mockViewController = mockObjectAndProtocol([UIViewController class], @protocol(VMKViewModelControllerType));
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mockViewController];
//    UIStoryboardSegue *mockSegue = mock([UIStoryboardSegue class]);
//    [given(mockSegue.destinationViewController) willReturn:navVC];
//    
//    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.sut.collectionView selectItemAtIndexPath:first animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
//    [self.sut.collectionView selectItemAtIndexPath:first animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//    [given([self.mockDataSource viewModelAtIndexPath:first]) willReturn:self.mockCellViewModel];
//    [given(self.mockCellViewModel.viewModel) willReturn:self.mockChooseImageViewModel];
//    
//    [self.sut prepareForSegue:mockSegue sender:self];
//    
//    [(id<VMKViewModelControllerType>)verifyCount(mockViewController, times(1)) setViewModel:self.mockChooseImageViewModel];
//    [verifyCount(self.mockControllerModel, times(1)) controllerModelForSegue:mockSegue];
//}

#pragma mark - didFinishApplyingChangeSet

- (void)testDidFinishApplyingChangeSetDoesNotThrow {
    XCTAssertNoThrow([self.sut didFinishApplyingChangeSet]);
}

#pragma mark - dataSource:didChangeWithChangeSet:

- (void)testDataSourceDidChangeWithChangeSetCallsUpdatesOnCollectionView {
    self.sut.collectionView = self.fakeCollectionView;
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    assertThatInteger(self.fakeCollectionView.performBatchUpdatesCompletionCalled, equalToInteger(1));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionChanged {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionChanged sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();
    
    assertThatInteger(self.fakeCollectionView.reloadSectionsCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.reloadSectionsSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionInserted {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionInserted sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.insertSectionsCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.insertSectionsSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithSectionDeleted {
    [self setupChangeSetWithType:VMKSingleChangeTypeSectionDeleted sectionSet:[NSIndexSet indexSetWithIndex:0]];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.deleteSectionsCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.deleteSectionsSectionsParameter, is([NSIndexSet indexSetWithIndex:0]));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowChanged {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowChanged rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.reloadItemsAtIndexPathCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.reloadItemsAtIndexPathRowsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowInserted {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowInserted rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.insertItemsAtIndexPathCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.insertItemsAtIndexPathRowsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowDeleted {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowDeleted rows:rows movedToRows:nil];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.deleteItemsAtIndexPathCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.deleteItemsAtIndexPathRowsParameter, is(rows));
}

- (void)testDataSourceDidChangeWithChangeSetWithRowMoved {
    NSArray<NSIndexPath *> *rows = @[[NSIndexPath indexPathForRow:0 inSection:1]];
    NSArray<NSIndexPath *> *rowsToMove = @[[NSIndexPath indexPathForRow:1 inSection:23]];
    [self setupChangeSetWithType:VMKSingleChangeTypeRowMoved rows:rows movedToRows:rowsToMove];
    
    [self.sut dataSource:self.mockDataSource didChangeWithChangeSet:self.mockChangeSet];
    
    self.fakeCollectionView.performBatchUpdatesCompletionUpdateBlockParameter();

    assertThatInteger(self.fakeCollectionView.deleteItemsAtIndexPathCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.deleteItemsAtIndexPathRowsParameter, is(rows));
    
    assertThatInteger(self.fakeCollectionView.insertItemsAtIndexPathCalled, equalToInteger(1));
    assertThat(self.fakeCollectionView.insertItemsAtIndexPathRowsParameter, is(rowsToMove));
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

- (void)testSetEditingYesSetsYesOnDataSourceFrom {
    [self.sut setEditing:YES];
    
    [verifyCount(self.mockDataSource, times(1)) setEditing:YES];
}

#pragma mark - dataSource:cellIdentifierAtIndexPath:

- (void)testDataSourceCellIdentifierAtIndexPathReturnsCell {
    assertThat([self.sut dataSource:self.mockDataSource cellIdentifierAtIndexPath:self.mockIndexPath], is(@"Cell"));
}

#pragma mark - dataSource:configureCell:withViewModel:

- (void)testDataSourceConfigureCellWithViewModelNotThrowsIfCellNotConformViewCellType {
    XCTAssertNoThrow([self.sut dataSource:self.mockDataSource configureCell:self.mockCollectionViewCell withViewModel:self.mockCellViewModel]);
}

- (void)testDataSourceConfigureCellWithViewModelIsViewCellTypeCallsViewModel {
    UICollectionViewCell<VMKViewCellType> *mockCell = mockObjectAndProtocol([UICollectionViewCell class], @protocol(VMKViewCellType));
    
    [self.sut dataSource:self.mockDataSource configureCell:mockCell withViewModel:self.mockCellViewModel];
    
    [(id<VMKViewCellType>)verifyCount(mockCell, times(1)) setViewModel:self.mockCellViewModel];
}

#pragma mark - requestViewWithViewModel:atIndexPath:

- (void)testRequestViewWithViewModelAtIndexPath {
    [self.sut requestViewWithViewModel:self.mockAlertViewModel atIndexPath:self.mockIndexPath];
    
    assertThat(self.sut.alertController, notNilValue());
    assertThat(self.sut.alertController.popoverView, is(self.sut.view));
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

#pragma mark - helpers

- (void)setupChangeSetWithType:(VMKSingleChangeType)type sectionSet:(NSIndexSet *)indexSet {
    self.sut.collectionView = self.fakeCollectionView;
    
    [given(self.mockChangeSet.history) willReturn:@[self.mockSingleChange]];
    [given(self.self.mockSingleChange.type) willReturnUnsignedInteger:type];
    [given(self.mockSingleChange.sectionSet) willReturn:indexSet];
}

- (void)setupChangeSetWithType:(VMKSingleChangeType)type rows:(NSArray<NSIndexPath *> *)rows movedToRows:(NSArray<NSIndexPath *> *)movedToRows {
    
    self.sut.collectionView = self.fakeCollectionView;
    
    [given(self.mockChangeSet.history) willReturn:@[self.mockSingleChange]];
    [given(self.self.mockSingleChange.type) willReturnUnsignedInteger:type];
    [given(self.mockSingleChange.rows) willReturn:rows];
    [given(self.mockSingleChange.movedToRows) willReturn:movedToRows];
}

@end
