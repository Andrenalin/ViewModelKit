//
//  VMKTableViewDelegateTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 05/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKTableViewDataSource.h"
#import "VMKTableViewDelegate.h"

@interface VMKTableViewDelegateTests : XCTestCase
@property (nonatomic, strong) VMKTableViewDelegate *sut;
@property (nonatomic, strong) id<UITableViewDelegate> mockDelegate;

@property (nonatomic, strong) UITableView *mockTableView;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@property (nonatomic, strong) NSObject<UITableViewDelegate> *mockObject;
@property (nonatomic, strong) VMKTableViewDataSource *mockTableViewDataSource;
@property (nonatomic, strong) VMKViewModel<VMKCellType> *mockCellViewModel;
@end

@implementation VMKTableViewDelegateTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKTableViewDelegate alloc] init];
    
    self.mockDelegate = mockProtocol(@protocol(UITableViewDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockTableView = mock([UITableView class]);
    self.mockIndexPath = mock([NSIndexPath class]);
    self.mockObject = mock([NSObject class]);
    
    self.mockTableViewDataSource = mock([VMKTableViewDataSource class]);
    self.mockCellViewModel = mockObjectAndProtocol([VMKViewModel class], @protocol(VMKCellType));
    
    [given(self.mockTableView.dataSource) willReturn:self.mockTableViewDataSource];
    [given([self.mockTableViewDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:self.mockCellViewModel];
}

- (void)tearDown {
    self.mockDelegate = nil;
    self.mockTableView = nil;
    self.mockIndexPath = nil;
    self.mockObject = nil;
    self.mockTableViewDataSource = nil;
    self.mockCellViewModel = nil;
    
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

#pragma mark - tableView:willSelectRowAtIndexPath:

- (void)testTableViewWillSelectRowAtIndexPathCallsDelegate {
    [self.sut tableView:self.mockTableView willSelectRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDelegate, times(1)) tableView:self.mockTableView willSelectRowAtIndexPath:self.mockIndexPath];
}

- (void)testRespondsToSelectorTableViewWillSelectRowAtIndexPathIfImplementedByRealDelegate {
    assertThatBool([self.sut respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)], isTrue());
}

- (void)testRespondsToSelectorTableViewWillSelectRowAtIndexPathIfNotImplementedByRealDelegate {
    self.sut.delegate = (id<UITableViewDelegate>)[[NSObject alloc] init];
    assertThatBool([self.sut respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)], isFalse());
}

#pragma mark - tableView:didSelectRowAtIndexPath:

- (void)testTableViewDidSelectRowAtIndexPathCallsDelegate {
    [self.sut tableView:self.mockTableView didSelectRowAtIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDelegate, times(1)) tableView:self.mockTableView didSelectRowAtIndexPath:self.mockIndexPath];
}

- (void)testRespondsToSelectorTableViewDidSelectRowAtIndexPathIfImplementedByRealDelegate {
    assertThatBool([self.sut respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)], isTrue());
}

- (void)testRespondsToSelectorTableViewDidSelectRowAtIndexPathIfNotImplementedByRealDelegate {
    self.sut.delegate = (id<UITableViewDelegate>)[[NSObject alloc] init];
    assertThatBool([self.sut respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)], isFalse());
}


#pragma mark - tableView:viewForHeaderInSection:

- (void)testTableViewViewForHeaderInSectionReturnsNilIfDataSourceIsNotSet {
    [given(self.mockTableView.dataSource) willReturn:nil];
    
    assertThat([self.sut tableView:self.mockTableView viewForHeaderInSection:0], nilValue());
}

- (void)testTableViewViewForHeaderInSectionReturns {
    [self.sut tableView:self.mockTableView viewForHeaderInSection:4];
    
    [verifyCount(self.mockTableViewDataSource, times(1)) tableView:self.mockTableView headerViewAtSection:4];
}

#pragma mark - tableView:heightForHeaderInSection:

- (void)testTableViewHeightForHeaderInSectionCallsDelegate {
    [self.sut tableView:self.mockTableView heightForHeaderInSection:1];
    
    [verifyCount(self.mockDelegate, times(1)) tableView:self.mockTableView heightForHeaderInSection:1];
}

- (void)testRespondsToSelectorTableViewHeightForHeaderInSectionIfImplementedByRealDelegate {
    assertThatBool([self.sut respondsToSelector:@selector(tableView:heightForHeaderInSection:)], isTrue());
}

- (void)testRespondsToSelectorTableViewHeightForHeaderInSectionIfNotImplementedByRealDelegate {
    self.sut.delegate = (id<UITableViewDelegate>)[[NSObject alloc] init];
    assertThatBool([self.sut respondsToSelector:@selector(tableView:heightForHeaderInSection:)], isFalse());
}

#pragma mark - tableView:editingStyleForRowAtIndexPath:

- (void)testTableViewEditingStyleForRowAtIndexPathReturnsNoneIfDataSourceIsNotSet {
    [given(self.mockTableView.dataSource) willReturn:nil];
    
    assertThatUnsignedInteger([self.sut tableView:self.mockTableView editingStyleForRowAtIndexPath:self.mockIndexPath], equalToUnsignedInteger(UITableViewCellEditingStyleNone));
}

- (void)testTableViewEditingStyleForRowAtIndexPathReturnsNoneButCallsViewModelAtIndexPath {
    [given([self.mockTableViewDataSource viewModelAtIndexPath:self.mockIndexPath]) willReturn:nil];
    
    assertThatUnsignedInteger([self.sut tableView:self.mockTableView editingStyleForRowAtIndexPath:self.mockIndexPath], equalToUnsignedInteger(UITableViewCellEditingStyleNone));
    
    [verifyCount(self.mockTableViewDataSource, times(1)) viewModelAtIndexPath:self.mockIndexPath];
}

- (void)testTableViewEditingStyleForRowAtIndexPathReturnsInsert {
    [given([self.mockCellViewModel canInsert]) willReturnBool:YES];
    
    assertThatUnsignedInteger([self.sut tableView:self.mockTableView editingStyleForRowAtIndexPath:self.mockIndexPath], equalToUnsignedInteger(UITableViewCellEditingStyleInsert));
}

- (void)testTableViewEditingStyleForRowAtIndexPathReturnsDelete {
    [given([self.mockCellViewModel canDelete]) willReturnBool:YES];
    
    assertThatUnsignedInteger([self.sut tableView:self.mockTableView editingStyleForRowAtIndexPath:self.mockIndexPath], equalToUnsignedInteger(UITableViewCellEditingStyleDelete));
}

#pragma mark - tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath

- (void)testTableViewTargetIndexPathForMoveFromRowAtIndexPathCallsDelegate {
    NSIndexPath *mockIndexPath2 = mock([NSIndexPath class]);
    
    [given([self.mockDelegate tableView:self.mockTableView targetIndexPathForMoveFromRowAtIndexPath:self.mockIndexPath toProposedIndexPath:mockIndexPath2]) willReturn:self.mockIndexPath];
    
    [self.sut tableView:self.mockTableView targetIndexPathForMoveFromRowAtIndexPath:self.mockIndexPath toProposedIndexPath:mockIndexPath2];
    
    [verifyCount(self.mockDelegate, times(1)) tableView:self.mockTableView targetIndexPathForMoveFromRowAtIndexPath:self.mockIndexPath toProposedIndexPath:mockIndexPath2];
}

- (void)testTableViewTargetIndexPathForMoveFromRowAtIndexPathReturnsProposed {
    NSIndexPath *mockIndexPath2 = mock([NSIndexPath class]);
    self.sut.delegate = self.mockObject;
    
    NSIndexPath *result = [self.sut tableView:self.mockTableView targetIndexPathForMoveFromRowAtIndexPath:self.mockIndexPath toProposedIndexPath:mockIndexPath2];
    
    assertThat(result, is(mockIndexPath2));
}

#pragma mark - tableView:accessoryButtonTappedForRowWithIndexPath:

- (void)testTableViewAccessoryButtonTappedForRowWithIndexPathCallsDelegate {
    [self.sut tableView:self.mockTableView accessoryButtonTappedForRowWithIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockDelegate, times(1)) tableView:self.mockTableView accessoryButtonTappedForRowWithIndexPath:self.mockIndexPath];
}

- (void)testRespondsToSelectorTableViewAccessoryButtonTappedForRowWithIndexPathIfImplementedByRealDelegate {
    assertThatBool([self.sut respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)], isTrue());
}

- (void)testRespondsToSelectorTableViewAccessoryButtonTappedForRowWithIndexPathIfNotImplementedByRealDelegate {
    self.sut.delegate = (id<UITableViewDelegate>)[[NSObject alloc] init];
    assertThatBool([self.sut respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)], isFalse());
}

#pragma mark - tableView:editActionsForRowAtIndexPath:

- (void)testTableViewEditActionsForRowAtIndexPathReturnsNilIfDataSourceIsNil {
    [given(self.mockTableView.dataSource) willReturn:nil];
    
    assertThat([self.sut tableView:self.mockTableView editActionsForRowAtIndexPath:self.mockIndexPath], nilValue());
}

- (void)testTableViewEditActionsForRowAtIndexPathReturnsEmptyArray {
    id<VMKTableViewRowActionsType> mockRowActions = mockProtocol(@protocol(VMKTableViewRowActionsType));
    [given([self.mockCellViewModel rowActions]) willReturn:mockRowActions];
    
    NSArray *result = [self.sut tableView:self.mockTableView editActionsForRowAtIndexPath:self.mockIndexPath];
    
    assertThat(result, notNilValue());
    assertThat(result, hasCountOf(0));
}

@end
