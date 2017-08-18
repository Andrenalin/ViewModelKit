//
//  VMKEditDataSourceTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 20/12/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMultiSectionDataSource.h"
#import "VMKMultiRowDataSource.h"
#import "VMKChangeSet.h"

#import "VMKEditDataSource+Private.h"
#import "VMKInsertCellViewModel.h"

@interface VMKEditDataSourceTests : XCTestCase
@property (nonatomic, strong) VMKEditDataSource *sut;

@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) VMKDataSource *mockEditDataSource;
@property (nonatomic, strong) VMKMultiSectionDataSource *mockSectionDataSource;
@property (nonatomic, strong) VMKMultiRowDataSource *mockRowDataSource;
@property (nonatomic, strong) id<VMKDataSourceDelegate> mockDelegate;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockCellViewModel;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockCellViewModelAll;
@end

@implementation VMKEditDataSourceTests

- (void)setUp {
    [super setUp];
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.mockEditDataSource = mock([VMKDataSource class]);
    
    self.sut = [[VMKEditDataSource alloc] initWithDataSource:self.mockDataSource editDataSource:self.mockEditDataSource editAsSection:NO];
    
    self.mockSectionDataSource = mock([VMKMultiSectionDataSource class]);
    self.mockRowDataSource = mock([VMKMultiRowDataSource class]);
    self.sut.dataSource = self.mockSectionDataSource;
    
    self.mockDelegate = mockProtocol(@protocol(VMKDataSourceDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockCellViewModel = mock([VMKViewModel class]);
    self.mockCellViewModelAll = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    [given([self.mockCellViewModelAll canEdit]) willReturnBool:YES];
    [given([self.mockCellViewModelAll canMove]) willReturnBool:YES];
}

- (void)tearDown {
    self.mockDataSource = nil;
    self.mockEditDataSource = nil;
    self.mockSectionDataSource = nil;
    self.mockRowDataSource = nil;
    self.mockDelegate = nil;
    self.mockIndexPath = nil;
    self.mockCellViewModel = nil;
    self.mockCellViewModelAll = nil;
    
    self.sut = nil;

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsMockEditDataSource {
    assertThat(self.sut.editDataSource, is(self.mockEditDataSource));
}

- (void)testInitHasDataSource {
    assertThat(self.sut.dataSource, notNilValue());
}

#pragma mark - initWithDataSource

- (void)testInitWithDataSourceCreatesNewDataSourceWithDelegateOnItself {
    VMKEditDataSource *sut = [[VMKEditDataSource alloc] initWithDataSource:self.mockDataSource editDataSource:self.mockEditDataSource editAsSection:YES];
    
    assertThat(sut.dataSource.delegate, is(sut));
}

#pragma mark - sections

- (void)testSectionsCallsMultiDataSource {
    [self.sut sections];
    
    [verifyCount(self.mockSectionDataSource, times(1)) sections];
}

#pragma mark - rowsInSection:

- (void)testRowsInSectionZeroCallsMultiDataSource {
    [self.sut rowsInSection:0];
    
    [verifyCount(self.mockSectionDataSource, times(1)) rowsInSection:0];
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathCallsMultiDataSource {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:56];
    [self.sut viewModelAtIndexPath:indexPath];
    
    [verifyCount(self.mockSectionDataSource, times(1)) viewModelAtIndexPath:indexPath];
}

#pragma mark - headerViewModelAtSection:

- (void)testHeaderViewModelAtSectionTenCallsMultiDataSource {
    [self.sut headerViewModelAtSection:10];
    
    [verifyCount(self.mockSectionDataSource, times(1)) headerViewModelAtSection:10];
}

- (void)testHeaderViewModelAtSectionZeroReturnsNilIfNotImplementedByDataSource {
    self.sut.dataSource = self.mockRowDataSource;
    
    assertThat([self.sut headerViewModelAtSection:0], nilValue());
}

#pragma mark - titleForHeaderInSection:

- (void)testTitleForHeaderInSectionTenCallsMultiDataSource {
    [self.sut titleForHeaderInSection:10];
    
    [verifyCount(self.mockSectionDataSource, times(1)) titleForHeaderInSection:10];
}

- (void)testTitleForHeaderInSectionReturnsNilIfNotImplementedByDataSource {
    self.sut.dataSource = self.mockRowDataSource;
    
    assertThat([self.sut titleForHeaderInSection:0], nilValue());
}

#pragma mark - titleForFooterInSection:

- (void)testTitleForFooterInSectionTenCallsMultiDataSource {
    [self.sut titleForFooterInSection:10];
    
    [verifyCount(self.mockSectionDataSource, times(1)) titleForFooterInSection:10];
}

- (void)testTitleForFooterInSectionReturnsNilIfNotImplementedByDataSource {
    self.sut.dataSource = self.mockRowDataSource;
    
    assertThat([self.sut titleForFooterInSection:0], nilValue());
}

#pragma mark - sectionIndexTitles

- (void)testSectionIndexTitlesCallsMultiDataSource {
    [self.sut sectionIndexTitles];
    
    [verifyCount(self.mockSectionDataSource, times(1)) sectionIndexTitles];
}

- (void)testSectionIndexTitlesReturnsNilIfNotImplementedByDataSource {
    self.sut.dataSource = self.mockRowDataSource;
    
    assertThat([self.sut sectionIndexTitles], nilValue());
}

#pragma mark - sectionForSectionIndexTitle:

- (void)testSectionForSectionIndexTitleCallsMultiDataSource {
    [self.sut sectionForSectionIndexTitle:@"Test" atIndex:2];
    
    [verifyCount(self.mockSectionDataSource, times(1)) sectionForSectionIndexTitle:@"Test" atIndex:2];
}

- (void)testSectionForSectionIndexTitleReturnsNilIfNotImplementedByDataSource {
    self.sut.dataSource = self.mockRowDataSource;
    
    assertThatInteger([self.sut sectionForSectionIndexTitle:@"One" atIndex:0], equalToInteger(-1));
}

#pragma mark - dataSource:didUpdateChangeSet:

- (void)testDataSourceDidUpdateChangeSetCallsDelegate {
    VMKChangeSet *mockChangeSet = mock([VMKChangeSet class]);
    [self.sut dataSource:self.mockRowDataSource didUpdateChangeSet:mockChangeSet];
    
    [verifyCount(self.mockDelegate, times(1)) dataSource:self.sut didUpdateChangeSet:mockChangeSet];
}

#pragma mark - setEditing:

- (void)testSetEditingYesSetsEditing {
    self.sut.editing = YES;
    
    assertThatBool(self.sut.editing, isTrue());
}

- (void)testSetEditingYesSetsEditingOnDataSource {
    self.sut.editing = YES;
    
    [verifyCount(self.mockSectionDataSource, times(1)) setEditing:YES];
}

- (void)testSetEditingYesAddsEditDataSourceToDataSource {
    self.sut.editing = YES;
    
    [verifyCount(self.mockSectionDataSource, times(1)) addDataSource:self.mockEditDataSource];
}

- (void)testSetEditingYesTwiceAddsEditDataSourceOnlyOnceToDataSource {
    self.sut.editing = YES;

    self.sut.editing = YES;
    
    [verifyCount(self.mockSectionDataSource, times(1)) addDataSource:self.mockEditDataSource];
}

- (void)testSetEditingNoCallsRemoveDataSourceFromDataSource {
    self.sut.editing = YES;
    
    self.sut.editing = NO;
    
    [verifyCount(self.mockSectionDataSource, times(1)) removeDataSource:self.mockEditDataSource];
}

#pragma mark - canEditRowAtIndexPath:

- (void)testCanEditRowAtIndexPathReturnsFalseIfNotImplemented {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModel];
    
    assertThatBool([self.sut canEditRowAtIndexPath:self.mockIndexPath], isFalse());
}

- (void)testCanEditRowAtIndexPathReturnsTrue {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModelAll];
    
    assertThatBool([self.sut canEditRowAtIndexPath:self.mockIndexPath], isTrue());
    [verifyCount(self.mockCellViewModelAll, times(1)) canEdit];
}

#pragma mark - deleteAtIndexPath:

- (void)testDeleteAtIndexPathDoesNotThrowIfNotImplemented {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModel];
    
    XCTAssertNoThrow([self.sut deleteAtIndexPath:self.mockIndexPath]);
}

- (void)testDeleteAtIndexPathCallsDeleteDataOnViewModel {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModelAll];
    
    [self.sut deleteAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockCellViewModelAll, times(1)) deleteData];
}

#pragma mark - insertAtIndexPath:

- (void)testInsertAtIndexPathThrowsIfViewModelIsNotInsertCellViewModel {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModelAll];
    
    XCTAssertThrows([self.sut insertAtIndexPath:self.mockIndexPath]);
}

- (void)testInsertAtIndexPathCallsInsertDataOnViewModel {
    VMKInsertCellViewModel *mockInsertCellViewModel = mock([VMKInsertCellViewModel class]);
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:mockInsertCellViewModel];
    
    [self.sut insertAtIndexPath:self.mockIndexPath];
    
    [verifyCount(mockInsertCellViewModel, times(1)) insertData];
}

#pragma mark - canMoveRowAtIndexPath:

- (void)testCanMoveRowAtIndexPathReturnsFalseIfNotImplemented {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModel];
    
    assertThatBool([self.sut canMoveRowAtIndexPath:self.mockIndexPath], isFalse());
}

- (void)testCanMoveRowAtIndexPathReturnsTrue {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModelAll];
    
    assertThatBool([self.sut canMoveRowAtIndexPath:self.mockIndexPath], isTrue());
    [verifyCount(self.mockCellViewModelAll, times(1)) canMove];
}

#pragma mark - moveRowAtIndexPath:toIndexPath:

- (void)testMoveRowAtIndexPathToIndexPathDoesNotThrowIfNotImplemented {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModel];
    
    XCTAssertNoThrow([self.sut moveRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath]);
}

- (void)testMoveRowAtIndexPathToIndexPathCallsMoveToIndexPathOnViewModel {
    [given([self.mockSectionDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModelAll];
    
    [self.sut moveRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockCellViewModelAll, times(1)) moveToIndexPath:self.mockIndexPath];
}

@end
