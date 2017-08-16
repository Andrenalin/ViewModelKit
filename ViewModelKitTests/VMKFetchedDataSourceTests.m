//
//  VMKFetchedDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKFetchedDataSource+Private.h"

@interface VMKFetchedDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKFetchedDataSource *sut;

@property (nonatomic, strong) NSFetchedResultsController *mockFetchedResultsController;
@property (nonatomic, strong) id<VMKCellViewModelFactory> mockFactory;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKViewModelCache *mockViewModelCache;
@property (nonatomic, strong) VMKFetchedUpdater *mockFetchUpdater;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@property (nonatomic, strong) VMKChangeSet *mockChangeSet;
@end

@implementation VMKFetchedDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.mockFetchedResultsController = mock([NSFetchedResultsController class]);
    self.mockFactory = mockProtocol(@protocol(VMKCellViewModelFactory));
    self.sut = [[VMKFetchedDataSource alloc] initWithFetchedResultsController:self.mockFetchedResultsController factory:self.mockFactory];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    self.mockViewModelCache = mock([VMKViewModelCache class]);
    self.sut.viewModelCache = self.mockViewModelCache;
    self.mockFetchUpdater = mock([VMKFetchedUpdater class]);
    self.sut.fetchedUpdater = self.mockFetchUpdater;
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockViewModel = mock([VMKViewModel class]);
    self.mockChangeSet = mock([VMKChangeSet class]);
}

- (void)tearDown {
    self.mockFetchedResultsController = nil;
    self.mockFactory = nil;
    self.mockDelegate = nil;
    self.mockViewModelCache = nil;
    self.mockFetchUpdater = nil;
    self.mockIndexPath = nil;
    self.mockViewModel = nil;
    self.mockChangeSet = nil;
    
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsFetchedResultsControllerToMock {
    assertThat(self.sut.fetchedResultsController, is(self.mockFetchedResultsController));
}

- (void)testInitSetsFactoryToMock {
    assertThat(self.sut.factory, is(self.mockFactory));
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

- (void)testInitSetsViewModelCacheToMock {
    assertThat(self.sut.viewModelCache, is(self.mockViewModelCache));
}

- (void)testInitSetsFetchedUpdaterToMock {
    assertThat(self.sut.fetchedUpdater, is(self.mockFetchUpdater));
}

- (void)testInitSetsTitleHeaderSectionMinCounterTo10 {
    assertThatUnsignedInteger(self.sut.titleHeaderSectionMinCounter, equalToUnsignedInteger(10));
}

- (void)testInitSetsTitleIndexSectionMinCounterTo5 {
    assertThatUnsignedInteger(self.sut.titleIndexSectionMinCounter, equalToUnsignedInteger(5));
}

#pragma mark - sections

- (void)testSectionsReturnsSectionsFromFetchedResultsController {
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1"]];
    
    assertThatInteger([self.sut sections], equalToInteger(1));
}

#pragma mark - rowsInSection

- (void)testRowsInSectionCallsFetchedResultsController {
    [self.sut rowsInSection:2];
    
    [(NSFetchedResultsController *)verifyCount(self.mockFetchedResultsController, times(1)) sections];
}

#pragma mark - viewModelAtIndexPath

- (void)testViewModelAtIndexPathReturnsViewModelFromCache {
    [given([self.mockViewModelCache viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockViewModel];
    
    assertThat([self.sut viewModelAtIndexPath:self.mockIndexPath], is(self.mockViewModel));
}

- (void)testViewModelAtIndexPathNeverCallsSetViewModelOnCache {
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockViewModelCache, never()) setViewModel:anything() atIndexPath:anything()];
}

- (void)testViewModelAtIndexPathCallsFactoryWithObjectFromFetchedResultsController {
    NSManagedObject *mockManagedObject = mock([NSManagedObject class]);
    [given([self.mockFetchedResultsController objectAtIndexPath:self.mockIndexPath]) willReturn:mockManagedObject];
    
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockFactory, times(1)) cellViewModelForDataSource:self.sut object:mockManagedObject];
}

- (void)testViewModelAtIndexPathCallsSetViewModelOnCache {
    NSManagedObject *mockObject = mock([NSManagedObject class]);
    [given([self.mockFetchedResultsController objectAtIndexPath:self.mockIndexPath]) willReturn:mockObject];
    [given([self.mockFactory cellViewModelForDataSource:self.sut object:mockObject]) willReturn:self.mockViewModel];
    
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockViewModelCache, times(1)) setViewModel:self.mockViewModel atIndexPath:self.mockIndexPath];
}

#pragma mark - titleForHeaderInSection:

- (void)testTitleForHeaderInSectionReturnsNil {
    [given(self.mockFetchedResultsController.sectionIndexTitles) willReturn:@[@"Test"]];
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1", @"2"]];

    assertThat([self.sut titleForHeaderInSection:0], nilValue());
}

- (void)testTitleForHeaderInSectionReturnsNilIfSectionTitlesAreEmpty {
    [given(self.mockFetchedResultsController.sectionIndexTitles) willReturn:@[]];
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1", @"2"]];
    self.sut.titleHeaderSectionMinCounter = 0;
    
    assertThat([self.sut titleForHeaderInSection:0], nilValue());
}

- (void)testTitleForHeaderInSectionReturnsTest {
    [given(self.mockFetchedResultsController.sectionIndexTitles) willReturn:@[@"Test"]];
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1", @"2"]];
    self.sut.titleHeaderSectionMinCounter = 1;
    
    assertThat([self.sut titleForHeaderInSection:0], is(@"Test"));
}

#pragma mark - sectionIndexTitles:

- (void)testSectionIndexTitlesReturnsNil {
    [given(self.mockFetchedResultsController.sectionIndexTitles) willReturn:@[@"Test"]];
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1", @"2"]];
    
    assertThat([self.sut sectionIndexTitles], nilValue());
}

- (void)testSectionIndexTitlesReturnsTest {
    [given(self.mockFetchedResultsController.sectionIndexTitles) willReturn:@[@"Test"]];
    [given(self.mockFetchedResultsController.sections) willReturn:@[@"1", @"2"]];
    self.sut.titleIndexSectionMinCounter = 1;
    
    assertThat([self.sut sectionIndexTitles], containsIn(@[@"Test"]));
}

#pragma mark - sectionForSectionIndexTitle:

- (void)testSectionForSectionIndexTitle {
    [given([self.mockFetchedResultsController sectionForSectionIndexTitle:@"A" atIndex:2]) willReturnInteger:100];
    
    assertThatInteger([self.sut sectionForSectionIndexTitle:@"A" atIndex:2], equalToInteger(100));
}

#pragma mark - fetchedUpdater:didChangeWithChangeSet:

- (void)testFetchedUpdaterDidChangeWithChangeSetCallsCleanUponChangeSet {
    [self.sut fetchedUpdater:self.mockFetchUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockChangeSet, times(1)) cleanUp];
}

- (void)testFetchedUpdaterDidChangeWithChangeSetNeverCallsDelegateIfEmpty {
    [self.sut fetchedUpdater:self.mockFetchUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testFetchedUpdaterDidChangeWithChangeSetNeverCallsViewModelCacheIfEmpty {
    [self.sut fetchedUpdater:self.mockFetchUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testFetchedUpdaterDidChangeWithChangeSetCallsDelegateWithChangeSet {
    [given(self.mockChangeSet.history) willReturn:@[@"1"]];
    
    [self.sut fetchedUpdater:self.mockFetchUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:self.mockChangeSet];
}

- (void)testFetchedUpdaterDidChangeWithChangeSetCallsViewModelCacheWithChangeSet {
    [given(self.mockChangeSet.history) willReturn:@[@"1"]];

    [self.sut fetchedUpdater:self.mockFetchUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:self.mockChangeSet];
}

#pragma mark - setFetchedResultsController:

- (void)testSetFetchedResultsControllerDoesNotResetCacheIfTheSameObject {
    self.sut.fetchedResultsController = self.mockFetchedResultsController;
    
    [verifyCount(self.mockViewModelCache, never()) resetCache];
}

- (void)testSetFetchedResultsControllerResetCacheIfFetchedResultsControllerWasSet {
    self.sut.fetchedResultsController = nil;
    
    [verifyCount(self.mockViewModelCache, times(1)) resetCache];
}

- (void)testSetFetchedResultsControllerSetsDelegateToFetchedUpdater {
    self.sut.fetchedResultsController = nil;
    
    self.sut.fetchedResultsController = self.mockFetchedResultsController;

    [(NSFetchedResultsController *)verifyCount(self.mockFetchedResultsController, times(1)) setDelegate:self.mockFetchUpdater];
}

#pragma mark - viewModelCache

- (void)testViewModelCacheIsNotNil {
    VMKFetchedDataSource *sut = [[VMKFetchedDataSource alloc] initWithFetchedResultsController:nil factory:nil];
    
    assertThat(sut.viewModelCache, notNilValue());
}

#pragma mark - fetchedUpdater

- (void)testFetchedUpdaterIsNotNil {
    VMKFetchedDataSource *sut = [[VMKFetchedDataSource alloc] initWithFetchedResultsController:nil factory:nil];
    
    assertThat(sut.fetchedUpdater, notNilValue());
}

- (void)testFetchedUpdaterSetsDelegateToSut {
    VMKFetchedDataSource *sut = [[VMKFetchedDataSource alloc] initWithFetchedResultsController:nil factory:nil];
    
    assertThat(sut.fetchedUpdater.delegate, is(sut));
}

#pragma mark - automaticallyNotifiesObserversOfReportChanges

- (void)testAutomaticallyNotifiesObserversOfReportChangesReturnsNo {
    assertThatBool([VMKFetchedDataSource automaticallyNotifiesObserversForKey:@"reportChanges"], isFalse());
}

#pragma mark - setReportChanges:

- (void)testSetReportChangesYesSetsFetchedUpdaterReportChangesUpdate {
    self.sut.reportChanges = YES;
    
    [verifyCount(self.mockFetchUpdater, times(1)) setReportChangeUpdates:YES];
}

- (void)testSetReportChangesYesSetsToYes {
    self.sut.reportChanges = YES;
    
    assertThatBool(self.sut.reportChanges, isTrue());
}

- (void)testSetReportChangesYesSetsOnlyOnceFetchedUpdaterReportChangesUpdate {
    self.sut.reportChanges = YES;

    self.sut.reportChanges = YES;

    [verifyCount(self.mockFetchUpdater, times(1)) setReportChangeUpdates:YES];
}

@end
