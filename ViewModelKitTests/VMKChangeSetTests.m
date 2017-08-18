//
//  VMKChangeSet.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;

#import "VMKChangeSet.h"
#import "VMKSingleChange.h"


@interface VMKChangeSetTests : XCTestCase
@property (nonatomic, strong) VMKChangeSet *sut;
@property (nonatomic, strong) NSIndexPath *indexPath00;
@property (nonatomic, strong) NSIndexPath *indexPath01;
@property (nonatomic, strong) NSIndexPath *indexPath02;
@property (nonatomic, strong) NSIndexPath *indexPath10;
@property (nonatomic, strong) NSIndexPath *indexPath20;
@property (nonatomic, strong) NSIndexPath *indexPath22;
@end

@implementation VMKChangeSetTests

#pragma mark - test fixture

- (void)setUp {
    [super setUp];
    self.sut = [[VMKChangeSet alloc] init];
    
    self.indexPath00 = [NSIndexPath indexPathForRow:0 inSection:0];
    self.indexPath01 = [NSIndexPath indexPathForRow:1 inSection:0];
    self.indexPath02 = [NSIndexPath indexPathForRow:2 inSection:0];
    self.indexPath10 = [NSIndexPath indexPathForRow:0 inSection:1];
    self.indexPath20 = [NSIndexPath indexPathForRow:0 inSection:2];
    self.indexPath22 = [NSIndexPath indexPathForRow:2 inSection:2];
}

- (void)tearDown {
    self.indexPath00 = nil;
    self.indexPath01 = nil;
    self.indexPath02 = nil;
    self.indexPath10 = nil;
    self.indexPath20 = nil;
    self.indexPath22 = nil;
    
    self.sut = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testHistoryIsNotNil {
    assertThat(self.sut.history, notNilValue());
}

- (void)testHistoryIsEmpty {
    assertThatUnsignedInteger(self.sut.history.count, equalToUnsignedInteger(0));
}

#pragma mark - description

- (void)testDescriptionContainsChangeSet {
    assertThat([self.sut description], containsSubstring(@"VMKChangeSet"));
}

- (void)testDescriptionContainsHistoryCount {
    [self.sut insertedSectionAtIndex:2];
    [self.sut changedSectionAtIndex:4];

    assertThat([self.sut description], containsSubstring(@"with History of 2"));
}

- (void)testDescriptionContainsSingleChange {
    [self.sut insertedSectionAtIndex:2];
    assertThat([self.sut description], containsSubstring(@"VMKSingleChange"));
}

#pragma mark - isEqualToChangeSet

- (void)testIsEqualToChangeSetWithNil {
    assertThatBool([self.sut isEqualToChangeSet:nil], isFalse());
}

- (void)testIsEqualToChangeSetWithSelf {
    assertThatBool([self.sut isEqualToChangeSet:self.sut], isTrue());
}

- (void)testIsEqualToChangeSetOtherYes {
    assertThatBool([self.sut isEqualToChangeSet:[VMKChangeSet new]], isTrue());
}

- (void)testIsEqualToChangeSetOtherNo {
    [self.sut insertedSectionAtIndex:0];
    
    assertThatBool([self.sut isEqualToChangeSet:[VMKChangeSet new]], isFalse());
}

#pragma mark - isEqual

- (void)testIsEqualWithNil {
    assertThatBool([self.sut isEqual:nil], isFalse());
}

- (void)testIsEqualWithSelf {
    assertThatBool([self.sut isEqual:self.sut], isTrue());
}

- (void)testIsEqualWithOtherClass {
    assertThatBool([self.sut isEqual:self], isFalse());
}

- (void)testIsEqualWithOtherChangeSet {
    assertThatBool([self.sut isEqual:[VMKChangeSet new]], isTrue());
}

#pragma mark - hash

- (void)testHashIsTheSame {
    assertThatUnsignedInteger(self.sut.hash, equalToUnsignedInteger([VMKChangeSet new].hash));
}

- (void)testHashIsNotTheSame {
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath10];
    
    assertThatUnsignedInteger(self.sut.hash, isNot(equalToUnsignedInteger([VMKChangeSet new].hash)));
}

#pragma mark - NSCopying

- (void)testCopyWithZoneIsEqual {
    VMKChangeSet *copyOfSut = [self.sut copy];
    
    assertThat(copyOfSut, is(self.sut));
}

- (void)testCopyWithZoneDoesADeepCopy {
    VMKChangeSet *copyOfSut = [self.sut copy];
    [copyOfSut insertedSectionAtIndex:0];
    
    assertThat(copyOfSut, isNot(self.sut));
}

- (void)testCopyWithZoneDoesADeepCopyForMovedRows {
    VMKChangeSet *copyOfSut = [self.sut copy];

    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath10];
    
    assertThat(copyOfSut, isNot(self.sut));
}

#pragma mark - applySectionOffset:rowOffset

- (void)testApplySectionOffsetRowOffsetOnEmptyChangeSetDoesNotChangeHistory {
    [self.sut applySectionOffset:1 rowOffset:2];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testApplySectionOffsetRowOffsetChangesHistoryByTwoAndOne {
    [self.sut insertedRowAtIndexPath:self.indexPath01];
    
    [self.sut applySectionOffset:2 rowOffset:1];
    
    assertThat([self.sut.history.firstObject rowIndexPath], is(self.indexPath22));
}

#pragma mark - cleanUp

- (void)testCleanUpCreatesChangedSection {
    [self.sut insertedSectionAtIndex:0];
    [self.sut deletedSectionAtIndex:0];

    [self.sut cleanUp];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0] ]));
}

- (void)testCleanUpDoesNotChangeHistory {
    [self.sut deletedSectionAtIndex:0];
    [self.sut insertedSectionAtIndex:0];
    
    [self.sut cleanUp];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedSection:0], [[VMKSingleChange alloc] initWithInsertedSection:0] ]));
}

- (void)testCleanUpCreatesChangedSectionTwice {
    [self.sut insertedSectionAtIndex:0];
    [self.sut deletedSectionAtIndex:0];
    [self.sut insertedSectionAtIndex:1];
    [self.sut deletedSectionAtIndex:1];
    
    [self.sut cleanUp];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0], [[VMKSingleChange alloc] initWithChangedSection:1] ]));
}

- (void)testCleanUpHasNoEffectOnOtherChanges {
    [self.sut changedSectionAtIndex:0];
    [self.sut changedRowAtIndexPath:self.indexPath00];
    
    [self.sut cleanUp];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0], [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00] ]));
}

#pragma mark - changedIndexPathForPreviousIndexPath:

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfNoChanges {
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathNilReturnsNil {
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:nil];
    
    assertThat(result, nilValue());
}

#pragma mark section inserted

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextSectionIndexPathIfSectionInsertedBefore {
    [self.sut insertedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath10];
    
    assertThat(result, is(self.indexPath20));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextSectionIndexPathWithIfInsertedSameIndex {
    [self.sut insertedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath10));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfSectionInsertedAfter {
    [self.sut insertedSectionAtIndex:1];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

#pragma mark section deleted

- (void)testChangedIndexPathForPreviousIndexPathReturnsPreviousSectionIndexPathIfSectionDeletedBefore {
    [self.sut deletedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath10];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNilIfSectionWasDeleted {
    [self.sut deletedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, nilValue());
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfSectionDeletedAfter {
    [self.sut deletedSectionAtIndex:1];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

#pragma mark section changed

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfSectionChangedBefore {
    [self.sut changedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath10];
    
    assertThat(result, is(self.indexPath10));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfSectionWasChanged {
    [self.sut changedSectionAtIndex:0];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfSectionChangedAfter {
    [self.sut changedSectionAtIndex:1];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

#pragma mark row inserted

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextRowIndexPathIfRowInsertedBefore {
    [self.sut insertedRowAtIndexPath:self.indexPath00];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath02));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextRowIndexPathIfRowInsertedSameIndex {
    [self.sut insertedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath02));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowInsertedAfter {
    [self.sut insertedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowInsertedButDifferentSection {
    [self.sut insertedRowAtIndexPath:self.indexPath10];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

#pragma mark row deleted

- (void)testChangedIndexPathForPreviousIndexPathReturnsPreviousRowIndexPathIfRowDeletedBefore {
    [self.sut deletedRowAtIndexPath:self.indexPath00];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNilIfRowWasDeleted {
    [self.sut deletedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, nilValue());
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowDeletedAfter {
    [self.sut deletedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowDeletedButDifferentSection {
    [self.sut deletedRowAtIndexPath:self.indexPath10];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

#pragma mark row changed

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowChangedBefore {
    [self.sut changedRowAtIndexPath:self.indexPath00];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowWasChanged {
    [self.sut changedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowChangedAfter {
    [self.sut changedRowAtIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowChangedButDifferentSection {
    [self.sut changedRowAtIndexPath:self.indexPath10];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

#pragma mark row moved

- (void)testChangedIndexPathForPreviousIndexPathReturnsMovedIndexPathIfRowMoveFromSourceToDest {
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath20];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath20));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsPreviousRowIndexPathIfRowMovedBefore {
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath20];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowMovedAfter {
    [self.sut movedRowAtIndexPath:self.indexPath01 toIndexPath:self.indexPath20];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowMovedButDifferentSection {
    [self.sut movedRowAtIndexPath:self.indexPath10 toIndexPath:self.indexPath20];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextRowIndexPathIfRowMovedToBefore {
    [self.sut movedRowAtIndexPath:self.indexPath10 toIndexPath:self.indexPath00];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath02));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsNextRowIndexPathIfRowMovedToSameIndex {
    [self.sut movedRowAtIndexPath:self.indexPath10 toIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath02));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowMovedToAfter {
    [self.sut movedRowAtIndexPath:self.indexPath10 toIndexPath:self.indexPath01];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath00];
    
    assertThat(result, is(self.indexPath00));
}

- (void)testChangedIndexPathForPreviousIndexPathReturnsSameIndexPathIfRowMovedToButDifferentSection {
    [self.sut movedRowAtIndexPath:self.indexPath10 toIndexPath:self.indexPath20];
    
    NSIndexPath *result = [self.sut changedIndexPathForPreviousIndexPath:self.indexPath01];
    
    assertThat(result, is(self.indexPath01));
}

#pragma mark - insertedSectionAtIndex:

- (void)testInsertedSectionAtIndexZero {
    [self.sut insertedSectionAtIndex:0];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedSection:0] ]));
}

- (void)testInsertedSectionAtIndexZeroAndOne {
    [self.sut insertedSectionAtIndex:0];
    [self.sut insertedSectionAtIndex:1];

    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedSection:0], [[VMKSingleChange alloc] initWithInsertedSection:1] ]));
}

- (void)testInsertedSectionAtIndexZeroAndTwo {
    [self.sut insertedSectionAtIndex:0];
    [self.sut insertedSectionAtIndex:2];

    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedSection:0], [[VMKSingleChange alloc] initWithInsertedSection:2] ]));
}

#pragma mark - deletedSectionAtIndex:

- (void)testDeletedSectionAtIndexZero {
    [self.sut deletedSectionAtIndex:0];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedSection:0] ]));
}

- (void)testDeletedSectionAtIndexZeroAndOne {
    [self.sut deletedSectionAtIndex:0];
    [self.sut deletedSectionAtIndex:1];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedSection:0], [[VMKSingleChange alloc] initWithDeletedSection:1] ]));
}

- (void)testDeletedSectionAtIndexZeroAndTwo {
    [self.sut deletedSectionAtIndex:0];
    [self.sut deletedSectionAtIndex:2];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedSection:0], [[VMKSingleChange alloc] initWithDeletedSection:2] ]));
}

#pragma mark - changedSectionAtIndex:

- (void)testChangedSectionAtIndexZero {
    [self.sut changedSectionAtIndex:0];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0] ]));
}

- (void)testChangedSectionAtIndexZeroAndOne {
    [self.sut changedSectionAtIndex:0];
    [self.sut changedSectionAtIndex:1];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0], [[VMKSingleChange alloc] initWithChangedSection:1] ]));
}

- (void)testChangedSectionAtIndexZeroAndTwo {
    [self.sut changedSectionAtIndex:0];
    [self.sut changedSectionAtIndex:2];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedSection:0], [[VMKSingleChange alloc] initWithChangedSection:2] ]));
}

#pragma mark - insertedRowAtIndexPath:

- (void)testInsertedRowAtIndexPathNilDoesNotChangeHistory {
    [self.sut insertedRowAtIndexPath:nil];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testInsertedRowAtIndexZero {
    [self.sut insertedRowAtIndexPath:self.indexPath00];

    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedRow:self.indexPath00] ]));
}

- (void)testInsertedRowAtIndexZeroAndOne {
    [self.sut insertedRowAtIndexPath:self.indexPath00];
    [self.sut insertedRowAtIndexPath:self.indexPath01];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedRow:self.indexPath00], [[VMKSingleChange alloc] initWithInsertedRow:self.indexPath01] ]));
}

- (void)testInsertedRowAtIndexZeroAndTwo {
    [self.sut insertedRowAtIndexPath:self.indexPath00];
    [self.sut insertedRowAtIndexPath:self.indexPath02];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedRow:self.indexPath00], [[VMKSingleChange alloc] initWithInsertedRow:self.indexPath02] ]));
}

#pragma mark - deletedRowsAtIndexPath:

- (void)testDeletedRowAtIndexPathNilDoesNotChangeHistory {
    [self.sut deletedRowAtIndexPath:nil];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testDeletedRowAtIndexZero {
    [self.sut deletedRowAtIndexPath:self.indexPath00];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedRow:self.indexPath00] ]));
}

- (void)testDeletedRowAtIndexZeroAndOne {
    [self.sut deletedRowAtIndexPath:self.indexPath00];
    [self.sut deletedRowAtIndexPath:self.indexPath01];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedRow:self.indexPath00], [[VMKSingleChange alloc] initWithDeletedRow:self.indexPath01] ]));
}

- (void)testDeletedRowAtIndexZeroAndTwo {
    [self.sut deletedRowAtIndexPath:self.indexPath00];
    [self.sut deletedRowAtIndexPath:self.indexPath02];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithDeletedRow:self.indexPath00], [[VMKSingleChange alloc] initWithDeletedRow:self.indexPath02] ]));
}

#pragma mark - changedRowAtIndexPath:

- (void)testChangedRowAtIndexPathNilDoesNotChangeHistory {
    [self.sut changedRowAtIndexPath:nil];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testChangedRowAtIndexZero {
    [self.sut changedRowAtIndexPath:self.indexPath00];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00] ]));
}

- (void)testChangedRowAtIndexZeroAndOne {
    [self.sut changedRowAtIndexPath:self.indexPath00];
    [self.sut changedRowAtIndexPath:self.indexPath01];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00], [[VMKSingleChange alloc] initWithChangedRow:self.indexPath01] ]));
}

- (void)testChangedRowAtIndexZeroAndTwo {
    [self.sut changedRowAtIndexPath:self.indexPath00];
    [self.sut changedRowAtIndexPath:self.indexPath02];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00], [[VMKSingleChange alloc] initWithChangedRow:self.indexPath02] ]));
}

#pragma mark - movedRowAtIndex:toIndexPath:

- (void)testMovedRowAtIndexPathNilDoesNotChangeHistory {
    [self.sut movedRowAtIndexPath:nil toIndexPath:self.indexPath01];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testMovedRowAtIndexPathToNilDoesNotChangeHistory {
    [self.sut movedRowAtIndexPath:self.indexPath01 toIndexPath:nil];
    
    assertThat(self.sut.history, hasCountOf(0));
}

- (void)testMoveRowAtIndexPathZeroToIndexPathOne {
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath01];

    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithMovedRow:self.indexPath00 to:self.indexPath01] ]));
}

- (void)testMoveRowAtIndexPathZeroToIndexPathZeroDoesNothing {
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath00];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00] ]));
}

- (void)testInsertedSectionZeroAndMovedRowsInSectionZeroResultsInInsertedSectionsAndDeletedRowInSectionOne {
    [self.sut insertedSectionAtIndex:0];
    [self.sut movedRowAtIndexPath:self.indexPath00 toIndexPath:self.indexPath00];
    
    assertThat(self.sut.history, containsIn(@[ [[VMKSingleChange alloc] initWithInsertedSection:0], [[VMKSingleChange alloc] initWithChangedRow:self.indexPath00] ]));
}

@end
