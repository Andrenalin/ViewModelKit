//
//  VMKTableViewRowActionCreatorTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/01/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKTableViewDataSource.h"
#import "VMKTableViewRowActionCreator+Private.h"

@interface VMKTableViewRowActionCreatorTests : XCTestCase
@property (nonatomic, strong) VMKTableViewRowActionCreator *sut;

@property (nonatomic, strong) UITableView *mockTableView;
@property (nonatomic, strong) id<VMKTableViewRowActionsType> mockRowActionsType;

@property (nonatomic, strong) VMKTableViewRowActionViewModel *mockRowActionViewModel1;
@property (nonatomic, strong) VMKTableViewRowActionViewModel *mockRowActionViewModel2;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@end

@implementation VMKTableViewRowActionCreatorTests

- (void)setUp {
    [super setUp];
    
    self.mockTableView = mock([UITableView class]);
    self.mockRowActionsType = mockProtocol(@protocol(VMKTableViewRowActionsType));
    self.sut = [[VMKTableViewRowActionCreator alloc] initWithTableView:self.mockTableView rowActionsType:self.mockRowActionsType];
    
    self.mockIndexPath = mock([NSIndexPath class]);
}

- (void)tearDown {
    self.mockTableView = nil;
    self.mockRowActionsType = nil;
    self.mockRowActionViewModel1 = nil;
    self.mockRowActionViewModel2 = nil;
    self.mockIndexPath = nil;
    
    self.sut = nil;    

    [super tearDown];
}

- (void)setUpRowActions {
    self.mockRowActionViewModel1 = mock([VMKTableViewRowActionViewModel class]);
    [given(self.mockRowActionViewModel1.title) willReturn:@"Title1"];
    [given(self.mockRowActionViewModel1.backgroundColor) willReturn:[UIColor blackColor]];
    [given(self.mockRowActionViewModel1.style) willReturnUnsignedInteger:VMKTableViewRowActionViewModelStyleDestructive];

    self.mockRowActionViewModel2 = mock([VMKTableViewRowActionViewModel class]);
    [given(self.mockRowActionViewModel2.title) willReturn:@"Title2"];
    [given(self.mockRowActionViewModel2.backgroundColor) willReturn:[UIColor blueColor]];
    [given(self.mockRowActionViewModel2.style) willReturnUnsignedInteger:VMKTableViewRowActionViewModelStyleNormal];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsTableViewToMock {
    assertThat(self.sut.tableView, is(self.mockTableView));
}

- (void)testInitSetsRowActionsTypeToMock {
    assertThat(self.sut.rowActionsType, is(self.mockRowActionsType));
}

#pragma mark - tableViewRowActions

- (void)testTableViewRowActionsIsEmpty {
    assertThat([self.sut tableViewRowActions], hasCountOf(0));
}

- (void)testTableViewRowActionsHasOneEntry {
    [self setUpRowActions];
    [given([self.mockRowActionsType rowActions]) willReturn:@[self.mockRowActionViewModel1]];
    
    NSArray<UITableViewRowAction *> *result = [self.sut tableViewRowActions];
    
    assertThat(result, hasCountOf(1));
}

- (void)testTableViewRowActionsHasTwoEntry {
    [self setUpRowActions];
    [given([self.mockRowActionsType rowActions]) willReturn:@[self.mockRowActionViewModel1, self.mockRowActionViewModel2]];
    
    NSArray<UITableViewRowAction *> *result = [self.sut tableViewRowActions];
    
    assertThat(result, hasCountOf(2));
}

- (void)testTableViewRowActionsHasTitlesFromViewModel {
    [self setUpRowActions];
    [given([self.mockRowActionsType rowActions]) willReturn:@[self.mockRowActionViewModel1, self.mockRowActionViewModel2]];
    
    NSArray<UITableViewRowAction *> *result = [self.sut tableViewRowActions];
    
    assertThat(result, hasCountOf(2));
    assertThat(result[0].title, is(@"Title1"));
    assertThat(result[1].title, is(@"Title2"));
}

- (void)testTableViewRowActionsHasStylesFromViewModel {
    [self setUpRowActions];
    [given([self.mockRowActionsType rowActions]) willReturn:@[self.mockRowActionViewModel1, self.mockRowActionViewModel2]];
    
    NSArray<UITableViewRowAction *> *result = [self.sut tableViewRowActions];
    
    assertThat(result, hasCountOf(2));
    assertThatUnsignedInteger(result[0].style, equalToUnsignedInteger(UITableViewRowActionStyleDestructive));
    assertThatUnsignedInteger(result[1].style, equalToUnsignedInteger(UITableViewRowActionStyleNormal));
}

- (void)testTableViewRowActionsHasBackgroundColorsFromViewModel {
    [self setUpRowActions];
    [given([self.mockRowActionsType rowActions]) willReturn:@[self.mockRowActionViewModel1, self.mockRowActionViewModel2]];
    
    NSArray<UITableViewRowAction *> *result = [self.sut tableViewRowActions];
    
    assertThat(result, hasCountOf(2));
    assertThat(result[0].backgroundColor, is([UIColor blackColor]));
    assertThat(result[1].backgroundColor, is([UIColor blueColor]));
}

#pragma mark - handleRowAction:atIndexPath:

- (void)testHandleRowActionAtIndexPathCallsSwipeRowActionAtIndexPath {
    [self setUpRowActions];
    
    [self.sut handleRowAction:self.mockRowActionViewModel1 atIndexPath:self.mockIndexPath];

    [verifyCount(self.mockRowActionViewModel1, times(1)) swipedRowActionAtIndexPath:self.mockIndexPath];
}

- (void)testHandleRowActionAtIndexPathCallsSetEditingNoAnimtedYesOnTableView {
    [self setUpRowActions];
    
    [self.sut handleRowAction:self.mockRowActionViewModel1 atIndexPath:self.mockIndexPath];
    
    [verifyCount(self.mockTableView, times(1)) setEditing:NO animated:YES];
}

- (void)testHandleRowActionAtIndexPathCallsRequestViewWithViewModel {
    [self setUpRowActions];
    VMKViewModel *mockViewModel = mock([VMKViewModel class]);
    [given([self.mockRowActionViewModel1 swipedRowActionAtIndexPath:self.mockIndexPath]) willReturn:mockViewModel];
    VMKTableViewDataSource *mockDataSource = mock([VMKTableViewDataSource class]);
    [given(self.mockTableView.dataSource) willReturn:mockDataSource];
    
    [self.sut handleRowAction:self.mockRowActionViewModel1 atIndexPath:self.mockIndexPath];
    
    [verifyCount(mockDataSource, times(1)) requestViewWithViewModel:mockViewModel atIndexPath:self.mockIndexPath];
}

@end
