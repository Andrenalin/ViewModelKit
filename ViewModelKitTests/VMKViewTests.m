//
//  VMKViewTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 03/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKView.h"

@interface VMKViewTests : XCTestCase
@property (nonatomic, strong) VMKView *sut;
@property (nonatomic, assign) CGSize size;
@end

@implementation VMKViewTests

- (void)setUp {
    [super setUp];
    
    self.sut = [[VMKView alloc] init];
    
    self.size = CGSizeMake(42, 23);
    self.sut.preferedSize = self.size;
}

- (void)tearDown {
    self.sut = nil;    

    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsPreferedSizeWidth {
    assertThatInteger((NSInteger)self.sut.preferedSize.width, equalToInteger(42));
}

- (void)testInitSetsPreferedSizeHeight {
    assertThatInteger((NSInteger)self.sut.preferedSize.height, equalToInteger(23));
}

#pragma mark - intrinsicContentSize

- (void)testIntrinsicContentSizeWidth {
    assertThatInteger((NSInteger)self.sut.intrinsicContentSize.width, equalToInteger(42));
}

- (void)testIntrinsicContentSizeHeight {
    assertThatInteger((NSInteger)self.sut.intrinsicContentSize.height, equalToInteger(23));
}

#pragma mark - initWithCoder:

- (void)testInitWithCoderCallsDecodeCGSizeWithPreferedSize {
    NSCoder *mockCoder = mock([NSCoder class]);
    
    (void)[[VMKView alloc] initWithCoder:mockCoder];
    
    [verifyCount(mockCoder, times(1)) decodeCGSizeForKey:@"VMKViewPreferedSize"];
}

- (void)testInitWithCoderWithSutCoder {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sut];
    
    VMKView *sut = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    assertThatInteger((NSInteger)sut.preferedSize.width, equalToInteger(42));
    assertThatInteger((NSInteger)sut.preferedSize.height, equalToInteger(23));
}

#pragma mark - encodeWithCoder:

- (void)testEncodeWithCoderCallsEncodeCGSizeWithPreferedSize {
    NSCoder *mockCoder = mock([NSCoder class]);
    
    [self.sut encodeWithCoder:mockCoder];
    
    [verifyCount(mockCoder, times(1)) encodeCGSize:self.size forKey:@"VMKViewPreferedSize"];
}


@end
