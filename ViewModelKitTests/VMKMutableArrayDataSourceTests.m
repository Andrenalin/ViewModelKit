//
//  VMKMutableArrayDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 04/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMutableArrayDataSource+Private.h"

@interface VMKMutableArrayDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKMutableArrayDataSource *sut;

@property (nonatomic, strong) VMKArrayModel *mockArrayModel;
@property (nonatomic, strong) id<VMKCellViewModelFactory> mockFactory;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKViewModelCache *mockViewModelCache;
@property (nonatomic, strong) VMKArrayUpdater *mockArrayUpdater;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@property (nonatomic, strong) VMKChangeSet *mockChangeSet;
@end

@implementation VMKMutableArrayDataSourceTests

- (void)setUp {
    [super setUp];

    self.mockArrayModel = mock([VMKArrayModel class]);
    self.mockFactory = mockProtocol(@protocol(VMKCellViewModelFactory));
    self.sut = [[VMKMutableArrayDataSource alloc] initWithArrayModel:self.mockArrayModel factory:self.mockFactory];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    self.mockViewModelCache = mock([VMKViewModelCache class]);
    self.sut.viewModelCache = self.mockViewModelCache;
    self.mockArrayUpdater = mock([VMKArrayUpdater class]);
    self.sut.arrayUpdater = self.mockArrayUpdater;
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockViewModel = mock([VMKViewModel class]);
    self.mockChangeSet = mock([VMKChangeSet class]);

}

- (void)tearDown {
    self.mockArrayModel = nil;
    self.mockFactory = nil;
    self.mockDelegate = nil;
    self.mockViewModelCache = nil;
    self.mockArrayUpdater = nil;
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

- (void)testInitSetsArrayModelToMock {
    assertThat(self.sut.arrayModel, is(self.mockArrayModel));
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

- (void)testInitSetsArrayUpdaterToMock {
    assertThat(self.sut.arrayUpdater, is(self.mockArrayUpdater));
}

#pragma mark - viewModelCache

- (void)testViewModelCacheIsNotNil {
    VMKMutableArrayDataSource *sut = [[VMKMutableArrayDataSource alloc] initWithArrayModel:self.mockArrayModel factory:nil];
    
    assertThat(sut.viewModelCache, notNilValue());
}

#pragma mark - arrayUpdater

- (void)testArrayUpdaterIsNotNil {
    VMKArrayModel *arrayModel = [[VMKArrayModel alloc] initWithArray:@[]];
    
    VMKMutableArrayDataSource *sut = [[VMKMutableArrayDataSource alloc] initWithArrayModel:arrayModel factory:nil];
    
    assertThat(sut.arrayUpdater, notNilValue());
}

- (void)testArrayUpdaterSetsDelegateToSut {
    VMKArrayModel *arrayModel = [[VMKArrayModel alloc] initWithArray:@[]];

    VMKMutableArrayDataSource *sut = [[VMKMutableArrayDataSource alloc] initWithArrayModel:arrayModel factory:nil];
    
    assertThat(sut.arrayUpdater.delegate, is(sut));
}

#pragma mark - setUpBinding

- (void)testSetUpBinding {
    [self.sut setUpBinding];
    
    [verifyCount(self.mockArrayUpdater, times(1)) bindArray];
}

#pragma mark - sections

- (void)testSectionsReturnsOne {
    assertThatInteger([self.sut sections], equalToInteger(1));
}

#pragma mark - rowsInSection

- (void)testRowsInSectionCallsFetchedResultsController {
    [given(self.mockArrayModel.count) willReturnUnsignedInteger:123];
    
    assertThatInteger([self.sut rowsInSection:0], equalToInteger(123));
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
    NSObject *mockObject = mock([NSObject class]);
    [given([self.mockArrayModel objectAtIndex:(NSUInteger)self.mockIndexPath.row]) willReturn:mockObject];
    
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockFactory, times(1)) cellViewModelForDataSource:self.sut object:mockObject];
}

- (void)testViewModelAtIndexPathCallsSetViewModelOnCache {
    id mockObject = mock([NSObject class]);
    [given([self.mockArrayModel objectAtIndex:0]) willReturn:mockObject];
    [given([self.mockFactory cellViewModelForDataSource:self.sut object:mockObject]) willReturn:self.mockViewModel];
    
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockViewModelCache, times(1)) setViewModel:self.mockViewModel atIndexPath:self.mockIndexPath];
}

#pragma mark - arrayUpdater:didChangeWithChangeSet:

- (void)testArrayUpdaterDidChangeWithChangeSetNeverCallsDelegateIfEmpty {
    [self.sut arrayUpdater:self.mockArrayUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testArrayUpdaterDidChangeWithChangeSetNeverCallsViewModelCacheIfEmpty {
    [self.sut arrayUpdater:self.mockArrayUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut didUpdateChangeSet:anything()];
}

- (void)testArrayUpdaterDidChangeWithChangeSetCallsDelegateWithChangeSet {
    [given(self.mockChangeSet.history) willReturn:@[@"1"]];
    
    [self.sut arrayUpdater:self.mockArrayUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:self.mockChangeSet];
}

- (void)testArrayUpdaterDidChangeWithChangeSetCallsViewModelCacheWithChangeSet {
    [given(self.mockChangeSet.history) willReturn:@[@"1"]];
    
    [self.sut arrayUpdater:self.mockArrayUpdater didChangeWithChangeSet:self.mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:self.mockChangeSet];
}

@end
