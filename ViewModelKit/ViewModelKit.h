//
//  ViewModelKit.h
//  ViewModelKit
//
//  Created by Andre Trettin on 12.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

//! Project version number for ViewModelKit.
FOUNDATION_EXPORT double ViewModelKitVersionNumber;

//! Project version string for ViewModelKit.
FOUNDATION_EXPORT const unsigned char ViewModelKitVersionString[];

#import <ViewModelKit/VMKMacros.h>

// ViewModel
#import <ViewModelKit/VMKViewModel.h>
#import <ViewModelKit/VMKArrayModel.h>
#import <ViewModelKit/VMKEditingType.h>
#import <ViewModelKit/VMKImageEditingType.h>

#import <ViewModelKit/VMKCellViewModelFactory.h>

// Controller
#import <ViewModelKit/VMKAlertController.h>
#import <ViewModelKit/VMKAlertViewModel.h>
#import <ViewModelKit/VMKAlertViewModel+Private.h>
#import <ViewModelKit/VMKAlertViewModelType.h>

#import <ViewModelKit/VMKChooseImageController.h>
#import <ViewModelKit/VMKChooseImageAlertViewModel.h>
#import <ViewModelKit/VMKChooseImageViewModelType.h>

// ViewController
#import <ViewModelKit/VMKViewModelControllerType.h>
#import <ViewModelKit/VMKViewController.h>
#import <ViewModelKit/VMKTableViewController.h>
#import <ViewModelKit/VMKCollectionViewController.h>

#import <ViewModelKit/VMKControllerModel.h>

// UITableView
#import <ViewModelKit/VMKDataSourceViewModelType.h>

#import <ViewModelKit/VMKCellType.h>
#import <ViewModelKit/VMKInsertCellViewModel.h>

#import <ViewModelKit/VMKHeaderFooterType.h>

#import <ViewModelKit/VMKViewCellType.h>
#import <ViewModelKit/VMKTableViewCell.h>

#import <ViewModelKit/VMKViewHeaderFooterType.h>
#import <ViewModelKit/VMKTableViewHeaderFooterView.h>

#import <ViewModelKit/VMKTableViewDelegate.h>

#import <ViewModelKit/VMKTableViewDataSource.h>
#import <ViewModelKit/VMKTableViewDataSourceDelegate.h>

#import <ViewModelKit/VMKTableViewRowActionsType.h>
#import <ViewModelKit/VMKTableViewRowActionViewModel.h>

#import <ViewModelKit/VMKViewModelCache.h>
#import <ViewModelKit/VMKFetchedUpdater.h>
#import <ViewModelKit/VMKArrayUpdater.h>

// UICollectionView
#import <ViewModelKit/VMKCollectionViewDataSource.h>
#import <ViewModelKit/VMKCollectionViewDataSourceDelegate.h>
#import <ViewModelKit/VMKCollectionViewCell.h>
#import <ViewModelKit/VMKCollectionReusableHeaderView.h>

// DataSource
#import <ViewModelKit/VMKDataSource.h>
#import <ViewModelKit/VMKDataSourceType.h>
#import <ViewModelKit/VMKDataSourceDelegate.h>

#import <ViewModelKit/VMKMultipleDataSource.h>
#import <ViewModelKit/VMKMultiRowDataSource.h>
#import <ViewModelKit/VMKMultiSectionDataSource.h>
#import <ViewModelKit/VMKMappedChildDataSourceIndexPath.h>

#import <ViewModelKit/VMKEditDataSource.h>

#import <ViewModelKit/VMKGroupedDataSourceType.h>
#import <ViewModelKit/VMKGroupedDataSource.h>

#import <ViewModelKit/VMKArrayDataSource.h>
#import <ViewModelKit/VMKMutableArrayDataSource.h>
#import <ViewModelKit/VMKFetchedDataSource.h>

// Core Data
#import <ViewModelKit/VMKCoreDataViewModel.h>
#import <ViewModelKit/VMKChangeSet.h>
#import <ViewModelKit/VMKSingleChange.h>

// Observers and watchers
#import <ViewModelKit/VMKBindingUpdater.h>
#import <ViewModelKit/VMKObservable.h>
#import <ViewModelKit/VMKObservableManager.h>
#import <ViewModelKit/VMKObserverNotificationManager.h>
#import <ViewModelKit/VMKDeleteWatcher.h>
#import <ViewModelKit/VMKChangeWatcher.h>

// UIView
#import <ViewModelKit/UIView+VMKInspectables.h>
#import <ViewModelKit/VMKLabel.h>
#import <ViewModelKit/VMKImageView.h>
#import <ViewModelKit/VMKTextField.h>
#import <ViewModelKit/VMKTextView.h>
