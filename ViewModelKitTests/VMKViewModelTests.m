//
//  VMKViewModelTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKBindingUpdater.h"
#import "VMKObservableManager.h"
#import "FakeObject.h"

#import "VMKViewModel+Private.h"

@interface VMKViewModelTests : XCTestCase
@property (nonatomic, strong) VMKViewModel *sut;
@property (nonatomic, strong) VMKObservableManager *mockObservableManager;
@end

@implementation VMKViewModelTests

- (void)setUp {
    [super setUp];
    self.sut = [[VMKViewModel alloc] init];
    
    self.mockObservableManager = mock([VMKObservableManager class]);
    self.sut.externalBindingManager = self.mockObservableManager;
}

- (void)tearDown {
    self.mockObservableManager = nil;
    self.sut = nil;
    [super tearDown];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testSutObservableManagerIsNotNil {
    assertThat(self.sut.observableManager, notNilValue());
}

- (void)testExternalBindingManagerIsSetTo {
    assertThat(self.sut.externalBindingManager, is(self.mockObservableManager));
}

#pragma mark - bindingUpdaterOnSelector:

- (void)testBindingUpdaterOnSelectorReturnsAnObject {
    VMKBindingUpdater *result = [self.sut bindingUpdaterOnSelector:@selector(unbindAllConnections)];
    
    assertThat(result, notNilValue());
}

- (void)testBindingUpdaterOnSelectorReturnsUpdaterOnSut {
    VMKBindingUpdater *result = [self.sut bindingUpdaterOnSelector:@selector(unbindAllConnections)];
    
    assertThatBool([result isObserver:self.sut], isTrue());
}

- (void)testBindingUpdaterOnSelectorReturnsUpdaterWithSelector {
    VMKBindingUpdater *result = [self.sut bindingUpdaterOnSelector:@selector(unbindAllConnections)];
    
    assertThatBool([result isObserver:self.sut], isTrue());
}

#pragma mark - bindBindingDictionary:

- (void)testBindBindingDictionaryCallsAddObjectWithSutAndTestDictionary {
    VMKBindingDictionary *testDictionary = @{};

    [self.sut bindBindingDictionary:testDictionary];
    
    [verifyCount(self.mockObservableManager, times(1)) addObject:self.sut withBindings:testDictionary];
}

- (void)testBindBindingDictionaryCallsAddObjectWithSutAndTestDictionaryTwice {
    VMKBindingDictionary *testDictionary = @{};
    
    [self.sut bindBindingDictionary:testDictionary];
    [self.sut bindBindingDictionary:testDictionary];
    
    [verifyCount(self.mockObservableManager, times(2)) addObject:self.sut withBindings:testDictionary];
}

#pragma mark - bindUpdater:toKeyPath:

- (void)testBindUpdaterToFilePathCallsAddObjecForKeyPath {
    VMKBindingUpdater *testUpdater = mock([VMKBindingUpdater class]);
    
    [self.sut bindUpdater:testUpdater toKeyPath:@"testPath.myProperty"];
    
    [verifyCount(self.mockObservableManager, times(1)) addObject:self.sut forKeyPath:@"testPath.myProperty" bindingUpdater:testUpdater];
}

- (void)testBindUpdaterToFilePathCallsAddObjectForKeyPathTwice {
    VMKBindingUpdater *testUpdater = mock([VMKBindingUpdater class]);
    
    [self.sut bindUpdater:testUpdater toKeyPath:@"testPath.myProperty"];
    [self.sut bindUpdater:testUpdater toKeyPath:@"testPath.myProperty"];
    
    [verifyCount(self.mockObservableManager, times(2)) addObject:self.sut forKeyPath:@"testPath.myProperty" bindingUpdater:testUpdater];
}

#pragma mark - bindObject:updateAction:toKeyPath:

- (void)testBindObjectUpdateActionToFilePathCallsAddObjectForKeyPath {
    FakeObject *fakeObject = [[FakeObject alloc] init];
    
    [self.sut bindObject:fakeObject updateAction:@selector(observableProperty) toKeyPath:@"test"];
    
    [verifyCount(self.mockObservableManager, times(1)) addObject:self.sut forKeyPath:@"test" bindingUpdater:anything()];
}

- (void)testBindObjectUpdateActionToFilePathCallsAddObjectForKeyPathTwice {
    FakeObject *fakeObject = [[FakeObject alloc] init];
    
    [self.sut bindObject:fakeObject updateAction:@selector(observableProperty) toKeyPath:@"test"];
    [self.sut bindObject:fakeObject updateAction:@selector(observableProperty2) toKeyPath:@"test"];
    
    [verifyCount(self.mockObservableManager, times(2)) addObject:self.sut forKeyPath:@"test" bindingUpdater:anything()];
}

#pragma mark - unbindKeyPath:

- (void)testUnbindKeyPathCallsRemoveAllObserverForKeyPath {
    [self.sut unbindKeyPath:@"test.myPath"];
    
    [verifyCount(self.mockObservableManager, times(1)) removeAllObserverForKeyPath:@"test.myPath"];
}

- (void)testUnbindKeyPathCallsRemoveAllObserverForKeyPathTwice {
    [self.sut unbindKeyPath:@"test.myPath"];
    [self.sut unbindKeyPath:@"test.myPath"];
    
    [verifyCount(self.mockObservableManager, times(2)) removeAllObserverForKeyPath:@"test.myPath"];
}

#pragma mark - unbindObserver:

- (void)testUnbindObserverCallsRemoveBindingObserver {
    [self.sut unbindObserver:self];
    
    [verifyCount(self.mockObservableManager, times(1)) removeBindingObserver:self];
}

- (void)testUnbindObserverCallsRemoveBindingObserverTwice {
    [self.sut unbindObserver:self];
    [self.sut unbindObserver:self];
    
    [verifyCount(self.mockObservableManager, times(2)) removeBindingObserver:self];
}

#pragma mark - unbindObserver:fromKeyPath;

- (void)testUnbindObserverFromKeyPathCallsRemoveBindingObserver {
    [self.sut unbindObserver:self fromKeyPath:@"testpath"];
    
    [verifyCount(self.mockObservableManager, times(1)) removeBindingObserver:self forKeyPath:@"testpath"];
}

- (void)testUnbindObserverFromKeyPathCallsRemoveBindingObserverTwice {
    [self.sut unbindObserver:self fromKeyPath:@"testpath"];
    [self.sut unbindObserver:self fromKeyPath:@"testpath"];
    
    [verifyCount(self.mockObservableManager, times(2)) removeBindingObserver:self forKeyPath:@"testpath"];
}

#pragma mark - unbindAllConnections

- (void)testUnbindAllConnections {
    [self.sut unbindAllConnections];
    
    [verifyCount(self.mockObservableManager, times(1)) removeAllBindings];
}

#pragma mark - description

- (void)testDescriptionContainsObserves {
    NSString *result = [self.sut description];
    
    assertThat(result, containsSubstring(@"observes:\n"));
}

- (void)testDescriptionContainsBindings {
    NSString *result = [self.sut description];
    
    assertThat(result, containsSubstring(@"bindings:\n"));
}

@end
