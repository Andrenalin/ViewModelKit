//
//  VMKViewModelCacheTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 31.01.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKViewModelCache.h"
#import "VMKViewModel.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange+Private.h"

@interface VMKViewModelCacheTests : XCTestCase
@property (nonatomic, strong) VMKViewModelCache *sut;

@property (nonatomic, strong) NSIndexPath *oneRowIndexPath;
@property (nonatomic, strong) NSIndexPath *twoRowIndexPath;
@property (nonatomic, strong) NSIndexPath *oneSectionIndexPath;
@property (nonatomic, strong) NSIndexPath *twoSectionIndexPath;

@property (nonatomic, strong) VMKViewModel *oneViewModel;
@property (nonatomic, strong) VMKViewModel *twoViewModel;
@property (nonatomic, strong) VMKViewModel *threeViewModel;
@property (nonatomic, strong) VMKViewModel *fourViewModel;

@property (nonatomic, strong) VMKChangeSet *changeSet;
@end


@implementation VMKViewModelCacheTests

- (void)setUp {
    [super setUp];
    self.sut = [[VMKViewModelCache alloc] init];
    [self setUpIndexPath];
    [self setUpViewModel];
    self.changeSet = [VMKChangeSet new];
}

- (void)tearDown {
    self.changeSet = nil;
    [self tearDownViewModel];
    [self tearDownIndexPath];
    self.sut = nil;
    [super tearDown];
}

#pragma mark - setUps

- (void)setUpIndexPath {
    self.oneRowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.twoRowIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    self.oneSectionIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    self.twoSectionIndexPath = [NSIndexPath indexPathForRow:1 inSection:2];
}

- (void)tearDownIndexPath {
    self.oneRowIndexPath = nil;
    self.twoRowIndexPath = nil;
    self.oneSectionIndexPath = nil;
    self.twoSectionIndexPath = nil;
}

- (void)setUpViewModel {
    self.oneViewModel = [VMKViewModel new];
    self.twoViewModel = [VMKViewModel new];
    self.threeViewModel = [VMKViewModel new];
    self.fourViewModel = [VMKViewModel new];
}

- (void)tearDownViewModel {
    self.oneViewModel = nil;
    self.twoViewModel = nil;
    self.threeViewModel = nil;
    self.fourViewModel = nil;
}

#pragma mark - test helper

- (void)setUpViewModelCache {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];
    [self.sut setViewModel:self.twoViewModel atIndexPath:self.twoRowIndexPath];
    [self.sut setViewModel:self.threeViewModel atIndexPath:self.oneSectionIndexPath];
    [self.sut setViewModel:self.fourViewModel atIndexPath:self.twoSectionIndexPath];
}

- (void)checkWithArray:(NSArray *)viewModels {
    
    [self checkViewModel:viewModels[0] atIndexPath:self.oneRowIndexPath];
    [self checkViewModel:viewModels[1] atIndexPath:self.twoRowIndexPath];
    [self checkViewModel:viewModels[2] atIndexPath:self.oneSectionIndexPath];
    [self checkViewModel:viewModels[3] atIndexPath:self.twoSectionIndexPath];
}

- (void)checkViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
    if ([viewModel isKindOfClass:[VMKViewModel class]]) {
        assertThat([self.sut viewModelAtIndexPath:indexPath], is(viewModel));
    } else {
        assertThat([self.sut viewModelAtIndexPath:indexPath], nilValue());
    }
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

#pragma mark - viewModelAtIndexPath:

- (void)testViewModelAtIndexPathReturnsNil {
    VMKViewModel *vm = [self.sut viewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    assertThat(vm, nilValue());
}

#pragma mark - resetCache

- (void)testResetCache {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];

    [self.sut resetCache];
    
    assertThat([self.sut viewModelAtIndexPath:self.oneRowIndexPath], nilValue());
}

#pragma mark - setViewModel:atIndexPath:

- (void)testSetViewModelAtIndexSetTheViewModel {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];
    
    assertThat([self.sut viewModelAtIndexPath:self.oneRowIndexPath], is(self.oneViewModel));
}

- (void)testSetViewModelAtIndexSetTheViewModelAtIndexPath {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];
    
    assertThat([self.sut viewModelAtIndexPath:self.twoRowIndexPath], nilValue());
}

- (void)testSetViewModelAtIndexWithTwoDifferentViewModelsReturnsTheRightOne {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];
    [self.sut setViewModel:self.twoViewModel atIndexPath:self.twoRowIndexPath];
    
    assertThat([self.sut viewModelAtIndexPath:self.oneRowIndexPath], is(self.oneViewModel));
    assertThat([self.sut viewModelAtIndexPath:self.twoRowIndexPath], is(self.twoViewModel));
}

- (void)testSetViewModelAtIndexCanResetAViewModelAndOnlyTheNewOneIsSet {
    [self.sut setViewModel:self.oneViewModel atIndexPath:self.oneRowIndexPath];
    [self.sut setViewModel:self.twoViewModel atIndexPath:self.oneRowIndexPath];
    
    assertThat([self.sut viewModelAtIndexPath:self.oneRowIndexPath], is(self.twoViewModel));
}

- (void)testSetViewModelAtIndexSecondSectionWithoutSettingTheFirstSection {
    [self.sut setViewModel:self.threeViewModel atIndexPath:self.twoSectionIndexPath];
    
    assertThat([self.sut viewModelAtIndexPath:self.twoSectionIndexPath], is(self.threeViewModel));
}

#pragma mark - changeCacheWithChangeSet:

- (void)testChangeCacheWithChangeSet {
    [self setUpViewModelCache];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.threeViewModel, self.fourViewModel ]];
}

#pragma mark changeCacheWithChangeSet: changed sections

- (void)testChangeCacheWithChangeSetChangedSectionZeroDoesNothing {
    [self setUpViewModelCache];
    [self.changeSet changedSectionAtIndex:0];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.threeViewModel, self.fourViewModel ]];
}

#pragma mark changeCacheWithChangeSet: deleted sections

- (void)testChangeCacheWithChangeSetDeletedSectionZere {
    [self setUpViewModelCache];
    [self.changeSet deletedSectionAtIndex:0];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ [NSNull null], self.threeViewModel, self.fourViewModel, [NSNull null] ]];
}

- (void)testChangeCacheWithChangeSetDeletedSectionOne {
    [self setUpViewModelCache];
    [self.changeSet deletedSectionAtIndex:1];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.fourViewModel, [NSNull null] ]];
}

- (void)testChangeCacheWithChangeSetDeletedSectionTwo {
    [self setUpViewModelCache];
    [self.changeSet deletedSectionAtIndex:2];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.threeViewModel, [NSNull null] ]];
}

#pragma mark changeCacheWithChangeSet: inserted sections

- (void)testChangeCacheWithChangeSetInsertedSectionZero {
    [self setUpViewModelCache];
    [self.changeSet insertedSectionAtIndex:0];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ [NSNull null], [NSNull null], self.twoViewModel, self.threeViewModel ]];
}

- (void)testChangeCacheWithChangeSetInsertedSectionOne {
    [self setUpViewModelCache];
    [self.changeSet insertedSectionAtIndex:1];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, [NSNull null], self.threeViewModel ]];
}

- (void)testChangeCacheWithChangeSetInsertedSectionTwo {
    [self setUpViewModelCache];
    [self.changeSet insertedSectionAtIndex:2];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.threeViewModel, [NSNull null] ]];
}

#pragma mark changeCacheWithChangeSet: changed rows

- (void)testChangeCacheWithChangeSetChangedRowZero {
    [self setUpViewModelCache];
    [self.changeSet changedRowAtIndexPath:self.oneRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ [NSNull null], self.twoViewModel, self.threeViewModel, self.fourViewModel ]];
}

#pragma mark changeCacheWithChangeSet: deleted rows

- (void)testChangeCacheWithChangeSetDeletedRowZero {
    [self setUpViewModelCache];
    [self.changeSet deletedRowAtIndexPath:self.oneRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.twoViewModel, [NSNull null], self.threeViewModel, self.fourViewModel ]];
}

- (void)testChangeCacheWithChangeSetDeletedRowOne {
    [self setUpViewModelCache];
    [self.changeSet deletedRowAtIndexPath:self.twoRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, [NSNull null], self.threeViewModel, self.fourViewModel ]];
}

#pragma mark changeCacheWithChangeSet: inserted rows

- (void)testChangeCacheWithChangeSetInsertedRowZero {
    [self setUpViewModelCache];
    [self.changeSet insertedRowAtIndexPath:self.oneRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ [NSNull null], self.oneViewModel, self.threeViewModel, self.fourViewModel ]];
}

- (void)testChangeCacheWithChangeSetInsertedRowOne {
    [self setUpViewModelCache];
    [self.changeSet insertedRowAtIndexPath:self.twoRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, [NSNull null], self.threeViewModel, self.fourViewModel ]];
}

#pragma mark changeCacheWithChangeSet: moved rows

- (void)testChangeCacheWithChangeSetMovedRowZeroToRowThree {
    [self setUpViewModelCache];
    [self.changeSet movedRowAtIndexPath:self.oneRowIndexPath toIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.twoViewModel, [NSNull null], self.threeViewModel, self.fourViewModel ]];
}

- (void)testChangeCacheWithChangeSetMovedRowZeroToRowOne {
    [self setUpViewModelCache];
    [self.changeSet movedRowAtIndexPath:self.oneRowIndexPath toIndexPath:self.twoRowIndexPath];
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.twoViewModel, self.oneViewModel, self.threeViewModel, self.fourViewModel ]];
}

- (void)testChangeCacheWithChangeSetMovedRowZeroToRowZero {
    [self setUpViewModelCache];
    [self.changeSet movedRowAtIndexPath:self.oneRowIndexPath toIndexPath:self.twoRowIndexPath];
    VMKSingleChange *singleChange = self.changeSet.history.firstObject;
    singleChange.rowIndexPath = nil;
    
    [self.sut changeCacheWithChangeSet:self.changeSet];
    
    [self checkWithArray:@[ self.oneViewModel, self.twoViewModel, self.threeViewModel, self.fourViewModel ]];
}

#pragma mark - description

- (void)testDescriptionAfterInitHasZeroSections {
    NSString *description = [self.sut description];
    
    assertThat(description, containsSubstring(@"has 0 sections"));
}

- (void)testDescriptionWithOneViewModelHasAKeyInsideTheDescription {
    [self.sut setViewModel:self.threeViewModel atIndexPath:self.twoSectionIndexPath];

    NSString *description = [self.sut description];
    
    assertThat(description, containsSubstring(@"Key:"));
}

@end
