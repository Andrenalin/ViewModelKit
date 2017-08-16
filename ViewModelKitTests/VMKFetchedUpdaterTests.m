//
//  VMKFetchedUpdaterTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 14/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKFetchedUpdater+Private.h"

@interface VMKFetchedUpdaterTests : XCTestCase
@property (nonatomic, strong) VMKFetchedUpdater *sut;
@property (nonatomic, strong) id<VMKFetchedUpdaterDelegate> mockDelegate;
@property (nonatomic, strong) VMKChangeSet *mockChangeSet;

@property (nonatomic, strong) NSFetchedResultsController *mockFrc;
@property (nonatomic, strong) id<NSFetchedResultsSectionInfo> mockSectionInfo;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) NSIndexPath *mockNewIndexPath;
@end

@implementation VMKFetchedUpdaterTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKFetchedUpdater alloc] init];

    self.mockDelegate = mockProtocol(@protocol(VMKFetchedUpdaterDelegate));
    self.sut.delegate = self.mockDelegate;
    self.mockChangeSet = mock([VMKChangeSet class]);
    self.sut.changeSet = self.mockChangeSet;

    self.mockFrc = mock([NSFetchedResultsController class]);
    self.mockSectionInfo = mockProtocol(@protocol(NSFetchedResultsSectionInfo));
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockNewIndexPath = mock([NSIndexPath class]);
}

- (void)tearDown {

    self.mockNewIndexPath = nil;
    self.mockIndexPath = nil;
    self.mockSectionInfo = nil;
    self.mockFrc = nil;
    
    self.mockChangeSet = nil;
    self.mockDelegate = nil;
    
    self.sut = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDelegate {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

- (void)testInitSetsChangeSet {
    assertThat(self.sut.changeSet, is(self.mockChangeSet));
}

- (void)testInitHasNoChangeSets {
    VMKFetchedUpdater *sut = [[VMKFetchedUpdater alloc] init];
    
    assertThat(sut.changeSet, nilValue());
}

#pragma mark - controllerWillChangeContent:

- (void)testControllerWillChangeContentSetsChangeSet {
    self.sut.changeSet = nil;
    
    [self.sut controllerWillChangeContent:self.mockFrc];
    
    assertThat(self.sut.changeSet, notNilValue());
}

- (void)testControllerWillChangeContentSetsNewChangeSet {
    [self.sut controllerWillChangeContent:self.mockFrc];
    VMKChangeSet *first = self.sut.changeSet;
    
    [self.sut controllerWillChangeContent:self.mockFrc];
    
    assertThat(self.sut.changeSet, isNot(sameInstance(first)));
}

#pragma mark - controller:didChangeSection:atIndex:forChangeType:

- (void)testControllerDidChangeSectionAtIndexForChangeTypeInsertCallsInsertedSectionAtIndexZero {
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:0 forChangeType:NSFetchedResultsChangeInsert];
    
    [verifyCount(self.mockChangeSet, times(1)) insertedSectionAtIndex:0];
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeInsertCallsInsertedSectionAtIndexOne {
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:1 forChangeType:NSFetchedResultsChangeInsert];
    
    [verifyCount(self.mockChangeSet, times(1)) insertedSectionAtIndex:1];
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeDeleteCallsDeletedSectionAtIndexZero {
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:0 forChangeType:NSFetchedResultsChangeDelete];
    
    [verifyCount(self.mockChangeSet, times(1)) deletedSectionAtIndex:0];
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeDeleteCallsDeletedSectionAtIndexOne {
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:1 forChangeType:NSFetchedResultsChangeDelete];
    
    [verifyCount(self.mockChangeSet, times(1)) deletedSectionAtIndex:1];
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeMoveDoesNotThrow {
    XCTAssertNoThrow([self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:0 forChangeType:NSFetchedResultsChangeMove]);
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeUpdateDoesNotCallChange {
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:0 forChangeType:NSFetchedResultsChangeUpdate];
    
    [verifyCount(self.mockChangeSet, never()) changedSectionAtIndex:0];
}

- (void)testControllerDidChangeSectionAtIndexForChangeTypeUpdateCallsChangeIfReportIsChange {
    self.sut.reportChangeUpdates = YES;
    
    [self.sut controller:self.mockFrc didChangeSection:self.mockSectionInfo atIndex:0 forChangeType:NSFetchedResultsChangeUpdate];
    
    [verifyCount(self.mockChangeSet, times(1)) changedSectionAtIndex:0];
}

#pragma mark - controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:

- (void)testControllerDidChangeObjectAtIndexPathForChangeTypeInsertNewIndexPathCallsInsertedRow {
    
    [self.sut controller:self.mockFrc didChangeObject:self.sut atIndexPath:self.mockIndexPath forChangeType:NSFetchedResultsChangeInsert newIndexPath:self.mockNewIndexPath];
    
    [verifyCount(self.mockChangeSet, times(1)) insertedRowAtIndexPath:self.mockNewIndexPath];
}

- (void)testControllerDidChangeObjectAtIndexPathForChangeTypeDeleteNewIndexPathCallsDeletedRow {
    
    [self.sut controller:self.mockFrc didChangeObject:self.sut atIndexPath:self.mockIndexPath forChangeType:NSFetchedResultsChangeDelete newIndexPath:self.mockNewIndexPath];
    
    [verifyCount(self.mockChangeSet, times(1)) deletedRowAtIndexPath:self.mockIndexPath];
}

- (void)testControllerDidChangeObjectAtIndexPathForChangeTypeChangeNewIndexPathDoesNotCallChangedRow {
    
    [self.sut controller:self.mockFrc didChangeObject:self.sut atIndexPath:self.mockIndexPath forChangeType:NSFetchedResultsChangeUpdate newIndexPath:self.mockNewIndexPath];
    
    [verifyCount(self.mockChangeSet, never()) changedRowAtIndexPath:self.mockIndexPath];
}

- (void)testControllerDidChangeObjectAtIndexPathForChangeTypeChangeNewIndexPathCallsChangedRowIfReportChanges {
    self.sut.reportChangeUpdates = YES;
    
    [self.sut controller:self.mockFrc didChangeObject:self.sut atIndexPath:self.mockIndexPath forChangeType:NSFetchedResultsChangeUpdate newIndexPath:self.mockNewIndexPath];
    
    [verifyCount(self.mockChangeSet, times(1)) changedRowAtIndexPath:self.mockIndexPath];
}

- (void)testControllerDidChangeObjectAtIndexPathForChangeTypeMoveNewIndexPathCallsMovedRow {
    
    [self.sut controller:self.mockFrc didChangeObject:self.sut atIndexPath:self.mockIndexPath forChangeType:NSFetchedResultsChangeMove newIndexPath:self.mockNewIndexPath];
    
    [verifyCount(self.mockChangeSet, times(1)) movedRowAtIndexPath:self.mockIndexPath toIndexPath:self.mockNewIndexPath];
}

#pragma mark - controllerDidChangeContent

- (void)testControllerDidChangeContentCallsDelegate {
    [self.sut controllerDidChangeContent:self.mockFrc];
    
    [verifyCount(self.mockDelegate, times(1)) fetchedUpdater:self.sut didChangeWithChangeSet:self.mockChangeSet];
}

- (void)testControllerDidChangeContentDoesNoitCallDelegateIfChangeSetIsNotSet {
    self.sut.changeSet = nil;
    
    [self.sut controllerDidChangeContent:self.mockFrc];
    
    [verifyCount(self.mockDelegate, never()) fetchedUpdater:anything() didChangeWithChangeSet:anything()];
}

@end
