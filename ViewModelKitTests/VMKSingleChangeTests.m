//
//  VMKSingleChangeTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 19/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKSingleChange+Private.h"

@interface VMKSingleChangeTests : XCTestCase
@property (nonatomic, strong) VMKSingleChange *sut;

@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) NSIndexPath *mockNewIndexPath;
@end

@implementation VMKSingleChangeTests

- (void)setUp {
    [super setUp];
    
    self.mockIndexPath = mock([NSIndexPath class]);
    [given(self.mockIndexPath.section) willReturnInteger:1];
    [given(self.mockIndexPath.row) willReturnInteger:2];
    
    self.mockNewIndexPath = mock([NSIndexPath class]);
    [given(self.mockNewIndexPath.section) willReturnInteger:3];
    [given(self.mockNewIndexPath.row) willReturnInteger:4];
    
    self.sut = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
}

- (void)tearDown {
    self.mockNewIndexPath = nil;
    self.mockIndexPath = nil;
    
    self.sut = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

#pragma mark - isEqualToSingleChange

- (void)testIsEqualToSingleChangeWithNil {
    assertThatBool([self.sut isEqualToSingleChange:nil], isFalse());
}

- (void)testIsEqualToSingleChangeWithSelf {
    assertThatBool([self.sut isEqualToSingleChange:self.sut], isTrue());
}

- (void)testIsEqualToSingleChangeOtherYes {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
    
    assertThatBool([self.sut isEqualToSingleChange:other], isTrue());
}

- (void)testIsEqualToSingleChangeReturnsNoIfTypeIsDifferent {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
    other.type = VMKSingleChangeTypeRowDeleted;

    assertThatBool([self.sut isEqualToSingleChange:other], isFalse());
}

- (void)testIsEqualToSingleChangeReturnsNoIfSectionIsDifferent {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
    other.section = 1;
    
    assertThatBool([self.sut isEqualToSingleChange:other], isFalse());
}

- (void)testIsEqualToSingleChangeReturnsNoIfRowIndexPathIsDifferent {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockNewIndexPath to:self.mockNewIndexPath];
    
    assertThatBool([self.sut isEqualToSingleChange:other], isFalse());
}

- (void)testIsEqualToSingleChangeReturnsNoIfMovedToIndexPathIsDifferent {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockIndexPath];
    
    assertThatBool([self.sut isEqualToSingleChange:other], isFalse());
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

- (void)testIsEqualWithOtherSingleChange {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];

    assertThatBool([self.sut isEqual:other], isTrue());
}

#pragma mark - hash

- (void)testHashIsTheSame {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
    
    assertThatUnsignedInteger(self.sut.hash, equalToUnsignedInteger(other.hash));
}

- (void)testHashIsNotTheSame {
    VMKSingleChange *other = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockIndexPath];
    
    assertThatUnsignedInteger(self.sut.hash, isNot(equalToUnsignedInteger(other.hash)));
}

- (void)testHashIsNotTheSameIfTypeHasChanged {
    NSUInteger hash = self.sut.hash;
    self.sut.type = VMKSingleChangeTypeRowChanged;
    
    assertThatUnsignedInteger(self.sut.hash, isNot(equalToUnsignedInteger(hash)));
}

- (void)testHashIsNotTheSameIfSectionHasChanged {
    self.sut.movedToRowIndexPath = nil;
    self.sut.rowIndexPath = nil;
    NSUInteger hash = self.sut.hash;
    self.sut.section = 4;
    
    assertThatUnsignedInteger(self.sut.hash, isNot(equalToUnsignedInteger(hash)));
}

#pragma mark - description

- (void)testDescriptionForChangedSection {
    self.sut.type = VMKSingleChangeTypeSectionChanged;
    self.sut.section = 0;
    
    assertThat([self.sut description], containsSubstring(@"Changed Section:0"));
}

- (void)testDescriptionForInsertedSection {
    self.sut.type = VMKSingleChangeTypeSectionInserted;
    self.sut.section = 1;
    
    assertThat([self.sut description], containsSubstring(@"Inserted Section:1"));
}

- (void)testDescriptionForDeletedSection {
    self.sut.type = VMKSingleChangeTypeSectionDeleted;
    self.sut.section = 2;
    
    assertThat([self.sut description], containsSubstring(@"Deleted Section:2"));
}

- (void)testDescriptionForChangedRow {
    self.sut.type = VMKSingleChangeTypeRowChanged;
    
    assertThat([self.sut description], containsSubstring(@"Changed Row:1-2"));
}

- (void)testDescriptionForInsertedRow {
    self.sut.type = VMKSingleChangeTypeRowInserted;
    
    assertThat([self.sut description], containsSubstring(@"Inserted Row:1-2"));
}

- (void)testDescriptionForDeletedRow {
    self.sut.type = VMKSingleChangeTypeRowDeleted;
    
    assertThat([self.sut description], containsSubstring(@"Deleted Row:1-2"));
}

- (void)testDescriptionForMovedRow {
    assertThat([self.sut description], containsSubstring(@"Moved Row:1-2 to:3-4"));
}

- (void)testDescriptionWithUnkownType {
    self.sut.type = NSNotFound;
    
    assertThat([self.sut description], containsSubstring(@"Unknown Type:Unknown Type"));
}

#pragma mark - sectionSet

- (void)testSectionSetReturnsSectionZero {
    self.sut.section = 0;
    NSIndexSet *expected = [NSIndexSet indexSetWithIndex:0];
    
    assertThat(self.sut.sectionSet, is(expected));
}

- (void)testSectionSetReturnsSectionOne {
    self.sut.section = 1;
    NSIndexSet *expected = [NSIndexSet indexSetWithIndex:1];
    
    assertThat(self.sut.sectionSet, is(expected));
}

#pragma mark - rows

- (void)testRowsIsEmptyIfRowIsNil {
    self.sut.rowIndexPath = nil;
    
    assertThat(self.sut.rows, hasCountOf(0));
}

- (void)testRowsHasOnlyNewIndexPath {
    self.sut.rowIndexPath = self.mockNewIndexPath;
    
    assertThat(self.sut.rows, hasItems(self.mockNewIndexPath, nil));
}

#pragma mark - movedToRows

- (void)testMoveToRowsIsEmptyIfRowIsNil {
    self.sut.movedToRowIndexPath = nil;
    
    assertThat(self.sut.movedToRows, hasCountOf(0));
}

- (void)testMoveToRowsHasOnlyNewIndexPath {
    self.sut.movedToRowIndexPath = self.mockIndexPath;
    
    assertThat(self.sut.movedToRows, hasItems(self.mockIndexPath, nil));
}

#pragma mark - applySectionOffset:rowOffset

- (void)testApplySectionOffsetThreeAddsThreeToSection {
    self.sut.type = VMKSingleChangeTypeSectionChanged;
    self.sut.section = 1;
    
    [self.sut applySectionOffset:3 rowOffset:1];
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(4));
    assertThat(self.sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

- (void)testApplySectionOffsetMinusThreeSubsThreeToSection {
    self.sut.type = VMKSingleChangeTypeSectionInserted;
    self.sut.section = 10;
    
    [self.sut applySectionOffset:-3 rowOffset:2];
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(7));
    assertThat(self.sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

- (void)testApplySectionOffsetAssertsIfResultIsNegative {
    self.sut.type = VMKSingleChangeTypeSectionDeleted;
    self.sut.section = 1;
    
    XCTAssertThrows([self.sut applySectionOffset:-2 rowOffset:0]);
    assertThat(self.sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

#pragma mark applyRowOffset:

- (void)testApplyRowOffsetFourAddsFourToRowAndMoveToIndexPath {
    self.sut.section = 3;
    
    [self.sut applySectionOffset:2 rowOffset:4];
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(3));
    assertThat(self.sut.rowIndexPath, is([NSIndexPath indexPathForRow:6 inSection:3]));
    assertThat(self.sut.movedToRowIndexPath, is([NSIndexPath indexPathForRow:8 inSection:5]));
}

- (void)testApplyRowOffsetThreeAddsThreeToOnlyRowIndexPath {
    self.sut.section = 3;
    self.sut.type = VMKSingleChangeTypeRowInserted;
    
    [self.sut applySectionOffset:0 rowOffset:3];
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(3));
    assertThat(self.sut.rowIndexPath, is([NSIndexPath indexPathForRow:5 inSection:1]));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

- (void)testApplyRowOffsetMinusRowOffsetSubsAndChangeRowIndexPath {
    self.sut.section = 3;
    self.sut.type = VMKSingleChangeTypeRowDeleted;
    
    [self.sut applySectionOffset:-1 rowOffset:-1];
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(3));
    assertThat(self.sut.rowIndexPath, is([NSIndexPath indexPathForRow:1 inSection:0]));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

- (void)testApplyRowOffsetMinusRowOffsetAssertsIfSectionIsNegative {
    self.sut.section = 3;
    self.sut.type = VMKSingleChangeTypeRowChanged;
    
    XCTAssertThrows([self.sut applySectionOffset:-2 rowOffset:-1]);
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(3));
    assertThat(self.sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

- (void)testApplyRowOffsetMinusRowOffsetAssertsIfRowIsNegative {
    self.sut.section = 3;
    self.sut.type = VMKSingleChangeTypeRowMoved;
    
    XCTAssertThrows([self.sut applySectionOffset:-1 rowOffset:-6]);
    
    assertThatUnsignedInteger(self.sut.section, equalToUnsignedInteger(3));
    assertThat(self.sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(self.sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

#pragma mark - initWithChangedSection:

- (void)testInitWithChangedSection {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithChangedSection:2];
    
    assertThat(sut, notNilValue());

    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeSectionChanged));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(2));
    
    assertThat(sut.rowIndexPath, nilValue());
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithInsertedSection:

- (void)testInitWithInsertedSection {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithInsertedSection:3];
    
    assertThat(sut, notNilValue());

    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeSectionInserted));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(3));
    assertThat(sut.rowIndexPath, nilValue());
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithDeletedSection:

- (void)testInitWithDeletedSection {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithDeletedSection:4];
    
    assertThat(sut, notNilValue());

    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeSectionDeleted));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(4));
    assertThat(sut.rowIndexPath, nilValue());
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithChangedRow:

- (void)testInitWithChangedRow {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithChangedRow:self.mockIndexPath];
    
    assertThat(sut, notNilValue());

    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeRowChanged));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(0));
    assertThat(sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithInsertedRow:

- (void)testInitWithInsertedRow {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithInsertedRow:self.mockIndexPath];
    
    assertThat(sut, notNilValue());
    
    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeRowInserted));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(0));
    assertThat(sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithDeletedRow:

- (void)testInitWithDeletedRow {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithDeletedRow:self.mockIndexPath];
    
    assertThat(sut, notNilValue());
    
    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeRowDeleted));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(0));
    assertThat(sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(sut.movedToRowIndexPath, nilValue());
}

#pragma mark - initWithMovedRow:to

- (void)testInitWithMovedRowTo {
    VMKSingleChange *sut = [[VMKSingleChange alloc] initWithMovedRow:self.mockIndexPath to:self.mockNewIndexPath];
    
    assertThat(sut, notNilValue());
    
    assertThatUnsignedInteger(sut.type, equalToUnsignedInteger(VMKSingleChangeTypeRowMoved));
    assertThatUnsignedInteger(sut.section, equalToUnsignedInteger(0));
    assertThat(sut.rowIndexPath, is(self.mockIndexPath));
    assertThat(sut.movedToRowIndexPath, is(self.mockNewIndexPath));
}

@end
