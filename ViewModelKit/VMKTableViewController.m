//
//  VMKTableViewController.m
//  ViewModelKit
//
//  Created by Andre Trettin on 27/12/15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

#import "VMKTableViewController.h"

#import "VMKTableViewCell.h"
#import "VMKTableViewDataSource.h"
#import "VMKTableViewDelegate.h"

#import "VMKControllerModel.h"
#import "VMKChangeSet.h"
#import "VMKSingleChange.h"


NS_ASSUME_NONNULL_BEGIN

@interface VMKTableViewController ()
@property (nonatomic, assign) BOOL observingViewModel;
@property (nonatomic, assign) BOOL observingAllowed;

@property (strong, nonatomic, nullable) __kindof VMKTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong, nullable) VMKTableViewDataSource *tableViewDataSource;
@end

NS_ASSUME_NONNULL_END


@implementation VMKTableViewController

#pragma mark - class methods

+ (BOOL)automaticallyNotifiesObserversOfViewModel {
    return NO;
}

#pragma mark - properties

- (VMKTableViewDelegate *)tableViewDelegate {
    if (!_tableViewDelegate) {
        _tableViewDelegate = [[VMKTableViewDelegate alloc] init];
        _tableViewDelegate.delegate = self;
    }
    return _tableViewDelegate;
}

- (VMKTableViewDataSource *)tableViewDataSource {
    if (_tableViewDataSource) {
        return _tableViewDataSource;
    }
    _tableViewDataSource = [[VMKTableViewDataSource alloc] initWithDataSource:self.viewModel.dataSource];
    _tableViewDataSource.delegate = self;
    
    return _tableViewDataSource;
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

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.delegate = self.tableViewDelegate;
    
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
    if (self.tableViewDataSource.dataSource != self.viewModel.dataSource) {
        self.tableViewDataSource = nil;
        
        self.tableView.dataSource = self.tableViewDataSource;
        [self.tableView reloadData];
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        VMKViewModel<VMKCellType> *cellViewModel = [self.viewModel.dataSource viewModelAtIndexPath:indexPath];
        vc.viewModel = cellViewModel.viewModel;
        vc.controllerModel = [self.controllerModel controllerModelForSegue:segue];
    }
}

#pragma mark - editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.viewModel.dataSource.editing = editing;
    self.controllerModel.editing = editing;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = nil;
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

#pragma mark - VMKTableViewDataSourceDelegate required

- (NSString *)dataSource:(VMKTableViewDataSource *)dataSource cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}

- (void)dataSource:(VMKTableViewDataSource *)dataSource configureCell:(UITableViewCell *)cell withViewModel:(__kindof VMKViewModel<VMKCellType> *)viewModel {
    
    if ([cell conformsToProtocol:@protocol(VMKViewCellType)]) {
        id<VMKViewCellType> viewModelCell = (id<VMKViewCellType>)cell;
        viewModelCell.viewModel = viewModel;
    }
}

- (void)dataSource:(VMKTableViewDataSource *)dataSource didChangeWithChangeSet:(VMKChangeSet *)changeSet {
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    [self.tableView beginUpdates];
    
    for (VMKSingleChange *singleChange in changeSet.history) {
        switch (singleChange.type) {
            case VMKSingleChangeTypeSectionChanged:
                [self.tableView reloadSections:singleChange.sectionSet withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case VMKSingleChangeTypeSectionInserted:
                [self.tableView insertSections:singleChange.sectionSet withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case VMKSingleChangeTypeSectionDeleted:
                [self.tableView deleteSections:singleChange.sectionSet withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case VMKSingleChangeTypeRowChanged:
                [self.tableView reloadRowsAtIndexPaths:singleChange.rows withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case VMKSingleChangeTypeRowInserted:
                [self.tableView insertRowsAtIndexPaths:singleChange.rows withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case VMKSingleChangeTypeRowDeleted:
                [self.tableView deleteRowsAtIndexPaths:singleChange.rows withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case VMKSingleChangeTypeRowMoved:
                [self.tableView deleteRowsAtIndexPaths:singleChange.rows withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:singleChange.movedToRows withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
        }
    }
    
    [self.tableView endUpdates];
    
    selectedIndexPath = [changeSet changedIndexPathForPreviousIndexPath:selectedIndexPath];
    if (selectedIndexPath) {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)requestViewWithViewModel:(VMKViewModel *)viewModel atIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self presentControllerWithViewModel:viewModel inView:cell];
}

#pragma mark - VMKTableViewDataSourceDelegate optional section header

- (NSString *)dataSource:(VMKTableViewDataSource *)dataSource headerViewIdentifierAtSection:(NSInteger)section {
    return @"SectionCell";
}

- (void)dataSource:(VMKTableViewDataSource *)dataSource configureHeaderView:(UITableViewHeaderFooterView *)headerFooterView withViewModel:(VMKViewModel<VMKHeaderFooterType> *)viewModel {
    
    if ([headerFooterView conformsToProtocol:@protocol(VMKViewHeaderFooterType)]) {
        id<VMKViewHeaderFooterType> viewModelCell = (id<VMKViewHeaderFooterType>)headerFooterView;
        viewModelCell.viewModel = viewModel;
    }
}

@end
