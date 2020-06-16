//
//  VMKCollectionViewController.m
//  ViewModelKit
//
//  Created by Daniel Rinser on 04.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "VMKCollectionViewController.h"

#import "VMKCollectionViewCell.h"
#import "VMKCollectionViewDataSource.h"

#import "VMKControllerModel.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"

#import "VMKViewHeaderFooterType.h"


@interface VMKCollectionViewController ()
@property (nonatomic, assign) BOOL observingViewModel;
@property (nonatomic, assign) BOOL observingAllowed;

@property (nonatomic, strong, nullable) VMKCollectionViewDataSource *collectionViewDataSource;
@end

@implementation VMKCollectionViewController

#pragma mark - class methods

+ (BOOL)automaticallyNotifiesObserversOfViewModel {
    return NO;
}

#pragma mark - properties

- (VMKCollectionViewDataSource *)collectionViewDataSource {
    if (_collectionViewDataSource) {
        return _collectionViewDataSource;
    }
    _collectionViewDataSource = [[VMKCollectionViewDataSource alloc] initWithDataSource:self.viewModel.dataSource];
    _collectionViewDataSource.delegate = self;
    
    return _collectionViewDataSource;
}

- (void)setViewModel:(__kindof VMKViewModel *)viewModel {
    
    if (_viewModel != viewModel) {
        [self unbindViewModel];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        _viewModel = viewModel;
        [self didChangeValueForKey:NSStringFromSelector(@selector(viewModel))];
        
        [self bindViewModel];
    }
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.collectionView.dataSource = self.collectionViewDataSource;
    
    self.observingAllowed = YES;
    [self bindViewModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.observingAllowed = NO;
    [self unbindViewModel];
}

#pragma mark - bindings

- (void)unbindViewModel {
    
    if (self.viewModel) {
        [self.viewModel unbindObserver:self];
        self.observingViewModel = NO;
    }
}

- (void)bindViewModel {
    
    if (self.viewModel && !self.observingViewModel && self.observingAllowed) {
        self.observingViewModel = YES;
        [self.viewModel startModelObservation];
        [self.viewModel bindBindingDictionary:[self viewModelBindings]];
    }
}

- (VMKBindingDictionary *)viewModelBindings {
    return @{ VMK_BINDING_PROPERTY(dataSource) };
}

- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction {
    return [VMKBindingUpdater bindingUpdaterWithObserver:self updateAction:updateAction];
}

- (BOOL)dataSourceDidChange {
    if (self.collectionViewDataSource.dataSource != self.viewModel.dataSource) {
        self.collectionViewDataSource = nil;
        
        self.collectionView.dataSource = self.collectionViewDataSource;
        return YES;
    }
    return NO;
}

#pragma mark - StoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController<VMKViewModelControllerType> *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navC = (UINavigationController *)vc;
        vc = (UIViewController<VMKViewModelControllerType> *)navC.topViewController;
    }
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    if (indexPath) {
        VMKViewModel<VMKCellType> *cellViewModel = [self.viewModel.dataSource viewModelAtIndexPath:indexPath];
        vc.viewModel = cellViewModel.viewModel;
        vc.controllerModel = [self.controllerModel controllerModelForSegue:segue];
    }
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.viewModel.dataSource.editing = editing;
    self.controllerModel.editing = editing;
}

#pragma mark - Subclassing hooks

- (void)didFinishApplyingChangeSet {
    // noop - just for subclassing
}

#pragma mark - presentController

- (void)presentControllerWithViewModel:(VMKViewModel *)viewModel inView:(UIView *)view {
    
    if (!viewModel) {
        return;
    }
    
    if (!view) {
        view = self.view;
    }
    
    if ([viewModel conformsToProtocol:@protocol(VMKAlertViewModelType)]) {
        [self presentAlertControllerWithViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel inView:view];
    }
    if ([viewModel conformsToProtocol:@protocol(VMKChooseImageViewModelType)]) {
        [self presentChooseImageControllerWithViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel inView:view];
    }
}

- (void)presentAlertControllerWithViewModel:(VMKViewModel<VMKAlertViewModelType> *)viewModel inView:(UIView *)view {
    
    self.alertController = [[VMKAlertController alloc] initWithViewController:self inPopoverView:view inSourceRect:view.bounds withViewModel:viewModel delegate:self];
    [self.alertController show];
}

- (void)presentChooseImageControllerWithViewModel:(VMKViewModel<VMKChooseImageViewModelType> *)viewModel inView:(UIView *)view {
    
    self.chooseImageController = [[VMKChooseImageController alloc] initWithViewController:self inPopoverView:view inSourceRect:view.bounds withViewModel:viewModel delegate:self];
    [self.chooseImageController show];
}

#pragma mark - VMKAlertControllerDelegate

- (void)alertController:(VMKAlertController *)alertController dismissedWithViewModel:(VMKViewModel *)viewModel {
    
    self.alertController = nil;
    [self presentControllerWithViewModel:viewModel inView:alertController.popoverView];
}

#pragma mark - VMKChooseImageControllerDelegate

- (void)chooseImageController:(VMKChooseImageController *)chooseImageController dismissedWithViewModel:(VMKViewModel *)viewModel {
    
    self.chooseImageController = nil;
    [self presentControllerWithViewModel:viewModel inView:chooseImageController.popoverView];
}

#pragma mark - VMKCollectionViewDataSourceDelegate required

- (NSString *)dataSource:(VMKCollectionViewDataSource *)dataSource cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}

#pragma mark - VMKCollectionViewDataSourceDelegate optional section header

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource configureHeaderView:(UICollectionReusableView *)headerView withViewModel:(__kindof VMKViewModel<VMKHeaderFooterType> *)viewModel {
    
    if ([headerView conformsToProtocol:@protocol(VMKViewHeaderFooterType)]) {
        id<VMKViewHeaderFooterType> viewModelHeader = (id<VMKViewHeaderFooterType>)headerView;
        viewModelHeader.viewModel = viewModel;
    }
}

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource configureCell:(UICollectionViewCell *)cell withViewModel:(__kindof VMKViewModel<VMKCellType> *)viewModel {
    
    if ([cell conformsToProtocol:@protocol(VMKViewCellType)]) {
        id<VMKViewCellType> viewModelCell = (id<VMKViewCellType>)cell;
        viewModelCell.viewModel = viewModel;
    }
}

- (void)dataSource:(VMKCollectionViewDataSource *)dataSource didChangeWithChangeSet:(VMKChangeSet *)changeSet {
  
    if (!self.disableChangeAnimations) {
        [self applyChangeSet:changeSet];
    } else {
        [UIView performWithoutAnimation:^{
            [self applyChangeSet:changeSet];
        }];
    }
}

- (void)applyChangeSet:(VMKChangeSet *)changeSet {

    [self.collectionView performBatchUpdates:^{
        
        [self updateWithChangetSet:changeSet];
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self didFinishApplyingChangeSet];
            
            // TODO: Support restoration of selected index path(s)
        }
    }];
}

- (void)updateWithChangetSet:(VMKChangeSet *)changeSet {
    for (VMKSingleChange *singleChange in changeSet.history) {
        switch (singleChange.type) {
            case VMKSingleChangeTypeSectionChanged:
                [self.collectionView reloadSections:singleChange.sectionSet];
                break;
            case VMKSingleChangeTypeSectionInserted:
                [self.collectionView insertSections:singleChange.sectionSet];
                break;
            case VMKSingleChangeTypeSectionDeleted:
                [self.collectionView deleteSections:singleChange.sectionSet];
                break;
                
            case VMKSingleChangeTypeRowChanged:
                [self.collectionView reloadItemsAtIndexPaths:singleChange.rows];
                break;
            case VMKSingleChangeTypeRowInserted:
                [self.collectionView insertItemsAtIndexPaths:singleChange.rows];
                break;
            case VMKSingleChangeTypeRowDeleted:
                [self.collectionView deleteItemsAtIndexPaths:singleChange.rows];
                break;
            case VMKSingleChangeTypeRowMoved:
                //[self.collectionView moveItemAtIndexPath:singleChange.rows toIndexPath:singleChange.movedToRows];
                
                [self.collectionView deleteItemsAtIndexPaths:singleChange.rows];
                [self.collectionView insertItemsAtIndexPaths:singleChange.movedToRows];
                break;
        }
    }
}

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(nonnull NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self presentControllerWithViewModel:viewModel inView:cell];
}

@end
