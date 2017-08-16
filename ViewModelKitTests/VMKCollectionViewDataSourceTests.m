//
//  VMKCollectionViewDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 27/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMultiSectionDataSource.h"
#import "VMKChangeSet.h"
#import "VMKCollectionViewDataSource+Private.h"

@interface VMKCollectionViewDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKCollectionViewDataSource *sut;

@property (nonatomic, strong) id<VMKCollectionViewDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) UICollectionView *mockCollectionView;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@property (nonatomic, strong) VMKMultiSectionDataSource *mockSectionDataSource;
@end

@implementation VMKCollectionViewDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKCollectionViewDataSource alloc] init];
    
    self.mockDelegate = mockProtocol(@protocol(VMKCollectionViewDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.sut.dataSource = self.mockDataSource;
    
    self.mockCollectionView = mock([UICollectionView class]);
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockViewModel = mock([VMKViewModel class]);
    self.mockSectionDataSource = mock([VMKMultiSectionDataSource class]);
}

- (void)tearDown {
    self.mockDelegate = nil;
    self.mockDataSource = nil;
    self.mockCollectionView = nil;
    self.mockIndexPath = nil;
    self.mockViewModel = nil;
    self.mockSectionDataSource = nil;
    
    self.sut = nil;

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

- (void)testInitSetsDataSourceToMock {
    assertThat(self.sut.dataSource, is(self.mockDataSource));
}

- (void)testInitSetsEditingToNo {
    assertThatBool(self.sut.editing, isFalse());
}

#pragma mark - initWithDataSource:

- (void)testInitWithDataSourceSetsDataSource {
    VMKCollectionViewDataSource *sut = [[VMKCollectionViewDataSource alloc] initWithDataSource:self.mockDataSource];
    assertThat(sut, notNilValue());
    assertThat(sut.dataSource, is(self.mockDataSource));
    [(VMKDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:sut];
}

#pragma mark - setDataSource:

- (void)testSetDataSourceSameObjectDoesNotCallSetDelegateAgain {
    self.sut.dataSource = self.mockDataSource;
    
    [(VMKDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:self.sut];
}

- (void)testSetDataSourceSecondDataSourceResetsDelegateOnFirstObject {
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat(self.sut.dataSource, is(self.mockSectionDataSource));
    [(VMKDataSource *)verifyCount(self.mockDataSource, times(1)) setDelegate:nilValue()];
}

#pragma mark - setEditing:

- (void)testSetEditingYesCallsSetEditingOnDataSource {
    self.sut.editing = YES;
    
    assertThatBool(self.sut.editing, isTrue());
    [(VMKDataSource *)verifyCount(self.mockDataSource, times(1)) setEditing:YES];
}

- (void)testSetEditingNoNeverCallSetEditingOnDataSource {
    self.sut.editing = NO;
    
    [(VMKDataSource *)verifyCount(self.mockDataSource, never()) setEditing:NO];
}

#pragma mark - numberOfSections

- (void)testNumberOfSectionsCallsDataSourceSections {
    [self.sut numberOfSections];
    
    [verifyCount(self.mockDataSource, times(1)) sections];
}

#pragma mark - numberOfRowsInSection:

- (void)testNumberOfItemsInSectionZeroCallsDataSourceRowsInSectionZero {
    [self.sut numberOfItemsInSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) rowsInSection:0];
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathCallsDataSourceViewModelAtIndexPath {
    [self.sut viewModelAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) viewModelAtIndexPath:self.mockIndexPath];
}

#pragma mark - requestViewWithViewModel:atIndexPath:

- (void)testRequestViewWithViewModelAtIndexPathCallsRequestViewModelAtIndexPath {
    [self.sut requestViewWithViewModel:self.mockViewModel atIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDelegate, times(1)) requestViewWithViewModel:self.mockViewModel atIndexPath:self.mockIndexPath];
}

#pragma mark - didUpdateChangeSet:

- (void)testDataSourceDidUpdateChangeSetCallsDelegateDataSourceDidChangeWithChangeSet {
    VMKChangeSet *mockChangeSet = mock([VMKChangeSet class]);
    
    [self.sut dataSource:self.mockDataSource didUpdateChangeSet:mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didChangeWithChangeSet:mockChangeSet];
}

#pragma mark - numberOfSectionsInCollectionView:

- (void)testNumberOfSectionsInCollectionViewCallsDataSourceSections {
    [self.sut numberOfSectionsInCollectionView:self.mockCollectionView];
    
    [verifyCount(self.mockDataSource, times(1)) sections];
}

#pragma mark - collectionView:numberOfItemsInSection:

- (void)testCollectionViewNumberOfItemsInSectionZeroCallsDataSourceRowsInSectionZero {
    [self.sut collectionView:self.mockCollectionView numberOfItemsInSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) rowsInSection:0];
}

#pragma mark - collectionView:cellForItemAtIndexPath:

- (void)testTableViewCellForRowAtIndexPathCallsDelegateMethods {
    [given([self.mockDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockViewModel];
    UICollectionViewCell *mockCell = mock([UICollectionViewCell class]);
    [given([self.mockCollectionView dequeueReusableCellWithReuseIdentifier:anything() forIndexPath:self.mockIndexPath]) willReturn:mockCell];
    [given([self.mockDelegate dataSource:self.sut cellIdentifierAtIndexPath:self.mockIndexPath]) willReturn:@"cellId"];
    assertThat([self.sut collectionView:self.mockCollectionView cellForItemAtIndexPath:self.mockIndexPath], is(mockCell));
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut cellIdentifierAtIndexPath:self.mockIndexPath];
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut configureCell:mockCell withViewModel:(id)self.mockViewModel];
}

#pragma mark - collectionView:canMoveItemAtIndexPath:

- (void)testCollectionViewCanMoveItemAtIndexPathCallsDataSourceCanEditRowAtIndexPath {
    [self.sut collectionView:self.mockCollectionView canMoveItemAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) canMoveRowAtIndexPath:self.mockIndexPath];
}

#pragma mark - collectionView:moveItemAtIndexPath:toIndexPath:

- (void)testCollectionViewMoveItemAtIndexPathToIndexPathCallsDataSourceMoveRowAtIndexPathToIndexPath {
    [self.sut collectionView:self.mockCollectionView moveItemAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) moveRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath];
}

@end
