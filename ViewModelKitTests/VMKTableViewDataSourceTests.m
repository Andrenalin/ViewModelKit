//
//  VMKTableViewDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 02/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKChangeSet.h"
#import "VMKTableViewDataSource+Private.h"
#import "VMKMultiSectionDataSource.h"

@interface VMKTableViewDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKTableViewDataSource *sut;

@property (nonatomic, strong) id<VMKTableViewDataSourceDelegate> mockDelegate;
@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) UITableView *mockTableView;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) VMKViewModel *mockViewModel;
@property (nonatomic, strong) VMKMultiSectionDataSource *mockSectionDataSource;
@end

@implementation VMKTableViewDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKTableViewDataSource alloc] init];
    
    self.mockDelegate = mockProtocol(@protocol(VMKTableViewDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.sut.dataSource = self.mockDataSource;
    
    self.mockTableView = mock([UITableView class]);
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockViewModel = mock([VMKViewModel class]);
    self.mockSectionDataSource = mock([VMKMultiSectionDataSource class]);
}

- (void)tearDown {
    self.mockDelegate = nil;
    self.mockDataSource = nil;
    self.mockTableView = nil;
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
    VMKTableViewDataSource *sut = [[VMKTableViewDataSource alloc] initWithDataSource:self.mockDataSource];
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

- (void)testNumberOfRowsInSectionZeroCallsDataSourceRowsInSectionZero {
    [self.sut numberOfRowsInSection:0];
    
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

#pragma mark - headerViewModelAtSection:

- (void)testHeaderViewModelAtSectionTwoNeverCallsDataSourceHeaderViewModelAtSectionTwo {
    [self.sut headerViewModelAtSection:2];
    
    [verifyCount(self.mockDataSource, never()) headerViewModelAtSection:2];
}

- (void)testHeaderViewModelAtSectionTwoCallsDataSourceHeaderViewModelAtSectionTwo {
    self.sut.dataSource = self.mockSectionDataSource;
    
    [self.sut headerViewModelAtSection:2];
    
    [verifyCount(self.mockSectionDataSource, times(1)) headerViewModelAtSection:2];
}

#pragma mark - numberOfSectionsInTableView:

- (void)testNumberOfSectionsInTableViewCallsDataSourceSections {
    [self.sut numberOfSectionsInTableView:self.mockTableView];
    
    [verifyCount(self.mockDataSource, times(1)) sections];
}

#pragma mark - tableView:numberOfRowsInSection:

- (void)testTableViewNumberOfRowsInSectionZeroCallsDataSourceRowsInSectionZero {
    [self.sut tableView:self.mockTableView numberOfRowsInSection:0];
    
    [verifyCount(self.mockDataSource, times(1)) rowsInSection:0];
}

#pragma mark - tableView:cellForRowAtIndexPath:

- (void)testTableViewCellForRowAtIndexPathCallsDelegateMethods {
    [given([self.mockDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockViewModel];
    UITableViewCell *mockCell = mock([UITableViewCell class]);
    [given([self.mockTableView dequeueReusableCellWithIdentifier:anything() forIndexPath:self.mockIndexPath]) willReturn:mockCell];
    [given([self.mockDelegate dataSource:self.sut cellIdentifierAtIndexPath:self.mockIndexPath]) willReturn:@"cellId"];
    
    assertThat([self.sut tableView:self.mockTableView cellForRowAtIndexPath:self.mockIndexPath], is(mockCell));
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut cellIdentifierAtIndexPath:self.mockIndexPath];
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut configureCell:mockCell withViewModel:(id)self.mockViewModel];
}

#pragma mark - tableView:titleForHeaderInSection:

- (void)testTableViewTitleForHeaderInSectionOneCallsDataSourceTitleForHeaderInSectionOne {
    [given([self.mockSectionDataSource titleForHeaderInSection:1]) willReturn:@"testHeaderTitle"];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat([self.sut tableView:self.mockTableView titleForHeaderInSection:1], is(@"testHeaderTitle"));
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut titleForHeaderInSection:1];
}

- (void)testTableViewTitleForHeaderInSectionOneCallsDelegateTitleForHeaderInSectionOneIfDataSourceReturnsNil {
    [given([self.mockSectionDataSource titleForHeaderInSection:1]) willReturn:nil];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat([self.sut tableView:self.mockTableView titleForHeaderInSection:1], nilValue());
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut titleForHeaderInSection:1];
}

- (void)testTableViewTitleForHeaderInSectionOneCallsDelegateTitleForHeaderInSectionOneIfDataSourceDoesNotRespond {
    assertThat([self.sut tableView:self.mockTableView titleForHeaderInSection:1], nilValue());
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut titleForHeaderInSection:1];
}

#pragma mark - tableView:titleForFooterInSection:

- (void)testTableViewTitleForFooterInSectionOneCallsDataSourceTitleForFooterInSectionOne {
    [given([self.mockSectionDataSource titleForFooterInSection:1]) willReturn:@"testFooterTitle"];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat([self.sut tableView:self.mockTableView titleForFooterInSection:1], is(@"testFooterTitle"));
    
    [verifyCount(self.mockDelegate, never()) dataSource:self.sut titleForFooterInSection:1];
}

- (void)testTableViewTitleForFoorerInSectionOneCallsDelegateTitleForFooterInSectionOneIfDataSourceReturnsNil {
    [given([self.mockSectionDataSource titleForFooterInSection:1]) willReturn:nil];
    self.sut.dataSource = self.mockSectionDataSource;

    assertThat([self.sut tableView:self.mockTableView titleForFooterInSection:1], nilValue());
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut titleForFooterInSection:1];
}

- (void)testTableViewTitleForFoorerInSectionOneCallsDelegateTitleForFooterInSectionOneIfDataSourceDoesNotRespond {
    assertThat([self.sut tableView:self.mockTableView titleForFooterInSection:1], nilValue());
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut titleForFooterInSection:1];
}

#pragma mark - sectionIndexTitlesForTableView:

- (void)testSectionIndexTitlesForTableViewCallsDataSourceSectionIndexTitles {
    [given([self.mockSectionDataSource sectionIndexTitles]) willReturn:@[@"1", @"2"]];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat([self.sut sectionIndexTitlesForTableView:self.mockTableView], containsIn(@[@"1", @"2"]));
}

- (void)testSectionIndexTitlesForTableViewReturnsNilIfDataSourceDoesNotResponds {
    assertThat([self.sut sectionIndexTitlesForTableView:self.mockTableView], nilValue());
}

#pragma mark - tableView:sectionForSectionIndexTitle:atIndex:

- (void)testTableViewSectionForSectionIndexTitleAtIndexCallsDataSourceSectionsForSectionIndexTitleAtIndex {
    [given([self.mockSectionDataSource sectionForSectionIndexTitle:@"test" atIndex:1]) willReturnInteger:4];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThatInteger([self.sut tableView:self.mockTableView sectionForSectionIndexTitle:@"test" atIndex:1], equalToInteger(4));
}

- (void)testTableViewSectionForSectionIndexTitleAtIndexReturnsMinusOneIfDataSourceDoesNotResponds {
    assertThatInteger([self.sut tableView:self.mockTableView sectionForSectionIndexTitle:@"nothing" atIndex:0], equalToInteger(-1));
}

#pragma mark - tableView:canEditRowAtIndexPath:

- (void)testTableViewCanEditRowAtIndexPathCallsDataSourceCanEditRowAtIndexPath {
    [self.sut tableView:self.mockTableView canEditRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) canEditRowAtIndexPath:self.mockIndexPath];
}

#pragma mark - tableView:commitEditingStyle:forRowAtIndexPath:

- (void)testTableViewCommitEditingStyleDeleteForRowAtIndexPathCallsDataSourceDeleteAtIndexPath {
    [self.sut tableView:self.mockTableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) deleteAtIndexPath:self.mockIndexPath];
    [verifyCount(self.mockDataSource, never()) insertAtIndexPath:self.mockIndexPath];
}

- (void)testTableViewCommitEditingStyleInsertForRowAtIndexPathCallsDataSourceInserAtIndexPath {
    [self.sut tableView:self.mockTableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, never()) deleteAtIndexPath:self.mockIndexPath];
    [verifyCount(self.mockDataSource, times(1)) insertAtIndexPath:self.mockIndexPath];
}

- (void)testTableViewCommitEditingStyleNoneForRowAtIndexPathNeverCallDataSource {
    [self.sut tableView:self.mockTableView commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, never()) deleteAtIndexPath:self.mockIndexPath];
    [verifyCount(self.mockDataSource, never()) insertAtIndexPath:self.mockIndexPath];
}

#pragma mark - tableView:canMoveRowAtIndexPath:

- (void)testTableViewCanMoveRowAtIndexPathCallsDataSourceCanEditRowAtIndexPath {
    [self.sut tableView:self.mockTableView canMoveRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) canMoveRowAtIndexPath:self.mockIndexPath];
}

#pragma mark - tableView:moveRowAtIndexPath:toIndexPath:

- (void)testTableViewMoveRowAtIndexPathToIndexPathCallsDataSourceMoveRowAtIndexPathToIndexPath {
    [self.sut tableView:self.mockTableView moveRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDataSource, times(1)) moveRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath];
}

#pragma mark - tableView:headerViewAtSection:

- (void)testTableViewHeaderViewAtSectionReturnsNilIfViewModelIsNil {
    [given([self.mockSectionDataSource headerViewModelAtSection:0]) willReturn:nil];
    self.sut.dataSource = self.mockSectionDataSource;
    
    assertThat([self.sut tableView:self.mockTableView headerViewAtSection:0], nilValue());
}

- (void)testTableViewHeaderViewAtSectionReturnsViewFromTableView {
    [given([self.mockDelegate dataSource:self.sut headerViewIdentifierAtSection:0]) willReturn:@"headerId"];
    [given([self.mockSectionDataSource headerViewModelAtSection:0]) willReturn:self.mockViewModel];
    self.sut.dataSource = self.mockSectionDataSource;
    
    UITableViewHeaderFooterView *mockView = mock([UITableViewHeaderFooterView class]);
    [given([self.mockTableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerId"]) willReturn:mockView];
    
    assertThat([self.sut tableView:self.mockTableView headerViewAtSection:0], is(mockView));
}

- (void)testTableViewHeaderViewAtSectionCallsDelegateMethods {
    [given([self.mockDelegate dataSource:self.sut headerViewIdentifierAtSection:0]) willReturn:@"headerId"];
    [given([self.mockSectionDataSource headerViewModelAtSection:0]) willReturn:self.mockViewModel];
    self.sut.dataSource = self.mockSectionDataSource;
    
    UITableViewHeaderFooterView *mockView = mock([UITableViewHeaderFooterView class]);
    [given([self.mockTableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerId"]) willReturn:mockView];

    assertThat([self.sut tableView:self.mockTableView headerViewAtSection:0], is(mockView));
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut headerViewIdentifierAtSection:0];
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut configureHeaderView:mockView withViewModel:(id)self.mockViewModel];
}

@end
