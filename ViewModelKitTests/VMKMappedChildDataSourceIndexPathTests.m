//
//  VMKMappedChildDataSourceIndexPathTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 20/11/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKMappedChildDataSourceIndexPath.h"

@interface VMKMappedChildDataSourceIndexPathTests : XCTestCase
@property (nonatomic, strong) VMKMappedChildDataSourceIndexPath *sut;

@property (nonatomic, strong) VMKDataSource *mockDataSource;
@property (nonatomic, strong) NSIndexPath *mockIndexPath;
@end

@implementation VMKMappedChildDataSourceIndexPathTests

- (void)setUp {
    [super setUp];
    
    self.mockDataSource = mock([VMKDataSource class]);
    self.mockIndexPath = mock([NSIndexPath class]);

    self.sut = [[VMKMappedChildDataSourceIndexPath alloc] initWithDataSource:self.mockDataSource offset:-3 indexPath:self.mockIndexPath];
}

- (void)tearDown {
    self.mockIndexPath = nil;
    self.mockDataSource = nil;
    self.sut = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsDataSource {
    assertThat(self.sut.dataSource, is(self.mockDataSource));
}

- (void)testInitSetsOffset {
    assertThatInteger(self.sut.offset, equalToInteger(-3));
}

- (void)testInitSetsIndexPath {
    assertThat(self.sut.indexPath, is(self.mockIndexPath));
}

#pragma mark - initWith

- (void)testInitSetsIndexPathToNil {
    VMKMappedChildDataSourceIndexPath *sut = [[VMKMappedChildDataSourceIndexPath alloc] initWithDataSource:self.mockDataSource offset:2 indexPath:nil];
    
    assertThat(sut, notNilValue());
    assertThat(sut.indexPath, nilValue());
    assertThatInteger(sut.offset, equalToInteger(2));
}

@end
