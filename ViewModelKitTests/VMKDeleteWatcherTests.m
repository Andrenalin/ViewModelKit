//
//  VMKDeleteWatcherTests.m
//  ViewModelKit
//
//  Created by Andre Trettin on 02/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

@import XCTest;
@import OCHamcrest;
@import OCMockito;

#import "VMKDeleteWatcher+Private.h"

@interface VMKDeleteWatcherTests : XCTestCase
@property (nonatomic, strong) VMKDeleteWatcher *sut;

@property (nonatomic, strong) NSPersistentStoreCoordinator *mockPersistentStoreCoordinator;
@property (nonatomic, strong) id<VMKDeleteWatcherDelegate> mockDelegate;
@property (nonatomic, strong) VMKObserverNotificationManager *mockObserverNotificationManager;
@property (nonatomic, strong) NSNotification *mockNotification;
@property (nonatomic, strong) NSManagedObject *mockManagedObject;
@property (nonatomic, strong) NSManagedObject *mockManagedObject2;
@property (nonatomic, strong) NSManagedObjectContext *mockManagedObjectContext;
@end

@implementation VMKDeleteWatcherTests

- (void)setUp {
    [super setUp];
    
    self.mockPersistentStoreCoordinator = mock([NSPersistentStoreCoordinator class]);
    self.sut = [[VMKDeleteWatcher alloc] initWithPersistentStoreCoordinator:self.mockPersistentStoreCoordinator];
    
    self.mockDelegate = mockProtocol(@protocol(VMKDeleteWatcherDelegate));
    self.sut.delegate = self.mockDelegate;
    
    self.mockObserverNotificationManager = mock([VMKObserverNotificationManager class]);
    self.sut.observerNotificationManager = self.mockObserverNotificationManager;
    
    self.mockManagedObject = mock([NSManagedObject class]);
    self.mockManagedObject2 = mock([NSManagedObject class]);
}

- (void)tearDown {
    self.mockPersistentStoreCoordinator = nil;
    self.mockDelegate = nil;
    self.mockObserverNotificationManager = nil;
    self.mockNotification = nil;
    self.mockManagedObject = nil;
    self.mockManagedObject2 = nil;
    self.mockManagedObjectContext = nil;
    
    self.sut = nil;    

    [super tearDown];
}

- (void)setUpNotification {
    self.mockNotification = mock([NSNotification class]);
    self.mockManagedObjectContext = mock([NSManagedObjectContext class]);

    [self.sut addObjectsToWatch:@[ self.mockManagedObject ]];
    
    [given(self.mockNotification.object) willReturn:self.mockManagedObjectContext];
    [given(self.mockManagedObjectContext.persistentStoreCoordinator) willReturn:self.mockPersistentStoreCoordinator];
    NSSet *deletedObjects = [NSSet setWithArray:@[self.mockManagedObject, self.mockManagedObject2]];
    [given(self.mockNotification.userInfo) willReturn:@{ NSDeletedObjectsKey: deletedObjects }];
}

#pragma mark - init

- (void)testSutIsNotNil {
    assertThat(self.sut, notNilValue());
}

- (void)testInitSetsPersistentStoreCoordinatorToMock {
    assertThat(self.sut.persistentStoreCoordinator, is(self.mockPersistentStoreCoordinator));
}

- (void)testInitSetsDelegateToMock {
    assertThat(self.sut.delegate, is(self.mockDelegate));
}

- (void)testInitSetsObjectsToWatchIsEmpty {
    assertThat(self.sut.objectsToWatch, notNilValue());
    assertThat(self.sut.objectsToWatch, hasCountOf(0));
}

- (void)testInitSetsObserverNotificationManagerToMock {
    assertThat(self.sut.observerNotificationManager, is(self.mockObserverNotificationManager));
}

#pragma mark - initWithPersistentStoreCoordinator:

- (void)testInitWithPersistentStoreCoordinatorObserverNotificationManagerIsNotNil {
    VMKDeleteWatcher *sut = [[VMKDeleteWatcher alloc] initWithPersistentStoreCoordinator:self.mockPersistentStoreCoordinator];
    
    assertThat(sut.observerNotificationManager, notNilValue());
}

#pragma mark - objectsToWatch

- (void)testObjectsToWatchCallsAddObserverForNameOnObserverNotificationManager {
    [self setUpNotification];
    
    [verifyCount(self.mockObserverNotificationManager, times(1)) addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil usingBlock:anything()];
}

- (void)testObjectsToWatchCallsDelegateDeleteWatcherWithDeletedObject {
    [self setUpNotification];
    
    HCArgumentCaptor *captor = [[HCArgumentCaptor alloc] init];
    [verifyCount(self.mockObserverNotificationManager, times(1)) addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil usingBlock:(id)captor];
   
    void (^handler)(NSNotification * _Nonnull notification) = captor.value;
    handler(self.mockNotification);
    [verifyCount(self.mockDelegate, times(1)) deleteWatcher:self.sut deletedObjects:anything()];
}

#pragma mark - handleObjectDidChangeNotification:

- (void)testhandleObjectDidChangeNotificationCallsDelegateDeleteWatcher {
    [self setUpNotification];
    
    [self.sut handleObjectDidChangeNotification:self.mockNotification];
    
    [verifyCount(self.mockDelegate, times(1)) deleteWatcher:self.sut deletedObjects:anything()];
}

- (void)testhandleObjectDidChangeNotificationNeverCallsDelegateDeleteWatcherIfObjectsAreNotTheSame {
    [self setUpNotification];
    self.sut.objectsToWatch = [NSMutableSet new];
    
    [self.sut handleObjectDidChangeNotification:self.mockNotification];
    
    [verifyCount(self.mockDelegate, never()) deleteWatcher:self.sut deletedObjects:anything()];
}

- (void)testhandleObjectDidChangeNotificationNeverCallsDelegateDeleteWatcherIfPersistentStoreIsNotTheSame {
    [self setUpNotification];
    [given(self.mockManagedObjectContext.persistentStoreCoordinator) willReturn:nil];
    
    [self.sut handleObjectDidChangeNotification:self.mockNotification];
    
    [verifyCount(self.mockDelegate, never()) deleteWatcher:self.sut deletedObjects:anything()];
}

- (void)testhandleObjectDidChangeNotificationCallsDelegateDeleteWatcherWithBothObjects {
    [self setUpNotification];
    [self.sut addObjectToWatch:self.mockManagedObject2];
    
    [self.sut handleObjectDidChangeNotification:self.mockNotification];
    
    HCArgumentCaptor *captor = [[HCArgumentCaptor alloc] init];
    [verifyCount(self.mockDelegate, times(1)) deleteWatcher:self.sut deletedObjects:(id)captor];
    NSSet *deletedObjects = captor.value;
    assertThat(deletedObjects, containsInAnyOrderIn(@[self.mockManagedObject, self.mockManagedObject2]));
}

#pragma mark - addObjectToWatch:

- (void)testAddObjectToWatchManagedObjectContainsOne {
    [self.sut addObjectToWatch:self.mockManagedObject];
    
    assertThat(self.sut.objectsToWatch, containsIn(@[self.mockManagedObject]));
}

- (void)testAddObjectToWatchManagedObjectTwiceContainsOne {
    [self.sut addObjectToWatch:self.mockManagedObject];
    [self.sut addObjectToWatch:self.mockManagedObject];
    
    assertThat(self.sut.objectsToWatch, containsIn(@[self.mockManagedObject]));
}

- (void)testAddObjectToWatchManagedObjectTwoContainsTwo {
    [self.sut addObjectToWatch:self.mockManagedObject];
    [self.sut addObjectToWatch:self.mockManagedObject2];
    
    assertThat(self.sut.objectsToWatch, containsInAnyOrderIn(@[self.mockManagedObject, self.mockManagedObject2]));
}

#pragma mark - addObjectsToWatch:

- (void)testAddObjectsToWatchManagedObjectContainsOne {
    [self.sut addObjectsToWatch:@[ self.mockManagedObject ]];
    
    assertThat(self.sut.objectsToWatch, containsIn(@[self.mockManagedObject]));
}

- (void)testAddObjectsToWatchManagedObjectContainsBoth {
    [self.sut addObjectsToWatch:@[ self.mockManagedObject, self.mockManagedObject2 ]];
    
    assertThat(self.sut.objectsToWatch, containsInAnyOrderIn(@[self.mockManagedObject, self.mockManagedObject2]));
}

- (void)testAddObjectsToWatchManagedObjectContainsOnlyTwo {
    [self.sut addObjectsToWatch:@[ self.mockManagedObject, self.mockManagedObject2, self.mockManagedObject, self.mockManagedObject2 ]];
    
    assertThat(self.sut.objectsToWatch, containsInAnyOrderIn(@[self.mockManagedObject, self.mockManagedObject2]));
}

@end
