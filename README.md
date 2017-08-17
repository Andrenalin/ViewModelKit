# ViewModelKit

[![Build Status](https://travis-ci.org/Andrenalin/ViewModelKit.svg?branch=develop)](https://travis-ci.org/Andrenalin/ViewModelKit)
[![Coverage Status](https://coveralls.io/repos/github/Andrenalin/ViewModelKit/badge.svg)](https://coveralls.io/github/Andrenalin/ViewModelKit)
[![codebeat badge](https://codebeat.co/badges/dc28778a-446d-4214-bffc-73789a3d4271)](https://codebeat.co/projects/github-com-andrenalin-viewmodelkit-develop)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

MVVM for iOS with objective-c based on KVO.

The ViewModelKit is a framework to support the iOS app development to use the MVVM paradigm. It uses KVO as binding technic to connect the models with view models and view controllers.

## Getting Started

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ViewModelKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Andrenalin/ViewModelKit" ~> 1.0
```

Run `carthage` to build the framework and drag the built `ViewModelKit.framework` into your Xcode project.

## How to use

### Simple observing

The observing works with two instances. The first object is a `VMKBindingUpdater` and the second is `VMKObservable`.

```obj-c
VMKBindingUpdater *bu = [[VMKBindingUpdater alloc] initWithObserver:self updateAction:@selector(nameDidChange)];

self.myObservable = [[VMKObservable alloc] initWithObject:self.model forKeyPath:@"name" bindingUpdater:bu];
[self.myObservable startObservation];
```

First create a `VMKBindingUpdater` instance that stores the connection between the observer and an update method.
In the example the method `nameDidChange` will be called on `self` and `self` is the observer.

Second create the `VMKObservable` with the model object that will be observed. The keypath must be property on the model object that is KVO compatible.
In the example the property `name` will be observed on the `self.model` object. Everytime the `name` has changed the `nameDidChange` method will be called on the observer `self`.

Don't forget to call `startObservation` method on the VMKObservable instance otherwise it will not observe the porperty.
The `startObservation` method does also a check if the property on the model and the updateAction method on the binding object exist.

It is best practise to have a strong reference to the model object (`self.model`) and the observable (`self.myObservable`).
KVO usually crashes if any of the involved objects are deallocated. The wrapper object `VMKBindingUpdater` and `VMKObservable` take care about this common issue.

The `VMKObservable` has a strong reference on the model object it will not crash but it is good practise to have also a strong reference in the observer instance.
The `VMKBindingUpdater` holds the observer as a weak property so that if you deallocating the observer the `VMKBindingUpdater` will not call the updateAction method anymore.
Also the `VMKObservable` instance can be deallocate ànytime and disconntects the KVO correctly.

### Create a ViewModel

The public header contains usually only readonly properties and can specify the model it belongs to. An init is not necessary if only one model is used.

```obj-c
@interface ExampleViewModel : VMKViewModel<ExampleModel *>
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger someNo;
@end
```

If the view model needs multiple or different model instances the type might be not specify.
For CoreData you can use the generic `VMKViewModel` class as super class or the specific `VMKCoreDataViewModel` class.
Both classes use only one model.

The private header declares the properties as readwrite to change the properties if the model has changed.

```obj-c
@interface ExampleViewModel ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, readwrite) NSInteger someNo;
@end
```

The implementation is something like that:

```obj-c
@implementation ExampleViewModel

#pragma mark - binding

- (VMKBindingDictionary *)modelBindings {
    return @{
        @"numberTwo": [self bindingUpdaterOnSelector:@selector(numberDidChange)],
        VMK_BINDING_KEYPATH_PROPERTY(@"numberOne", number),
        // @"numberOne": [self bindingUpdaterOnSelector:@selector(numberDidChange)],
        VMK_BINDING_PROPERTY(name)
        // NSStringFromSelector(@selector(name)): [self bindingUpdaterOnSelector:@selector(nameDidChange)],
    };
}

#pragma mark - update

- (void)nameDidChange {
    self.name = self.model.name;
}

- (void)numberDidChange {
    self.someNo = self.model.numberOne + self.model.numberTwo;
}

@end
```

The specific view model is binding the model properties to `xxxDidChange` methods on its own. Everytime the model properties are changing the `xxxDidChange` methods are calculating the properties of the ViewModel again.
In this example the ExampleModel and ExampleViewModel are more or less straight forward but there are more complex relationships possible between a Model and a ViewModel.

The `startModelObservation` from `VMKViewModel` class will use the `modelBindings` to connect the model with the view model. If it is not overwritten no bindings will be setup then the specific class is responsible to do the bindings.

One key feature of the ViewModelKit is the `VMKBindingDictionary *` type. It is a dictionary that describes how a model is binded to an observer. The key is a keypath to the model and the value is a `VMKBindingUpdater` instance. A VMKViewModel has a helper method `bindingUpdaterOnSelector:` to create a `VMBindingUpdater` instance direct on the view model.
The line: `@"numberTwo": [self bindingUpdaterOnSelector:@selector(numberDidChange)],` means connect the keypath `numberTwo` to the view model and call `numberDidChange` at the first connect and then after every change.

`VMK_BINDING_KEYPATH_PROPERTY(keypath, name of didChange)` is a macro to shorten the typing. The shortest version is `VMK_BINDING_PROPERTY(name)` and will use the `NSStringFromSelector(@selector(name))` for the keypath and create a default binding updater with the naming convention `nameDidChange`.`

### Create a ViewController

The definition of a custom ViewController looks like this:

```obj-c
@import ViewModelKit;

@interface ExampleViewController : VMKViewController<ExampleViewModel *>
@end
```

 The `VMKViewController` is a specialized class of the `UIViewController` and has several helper methods. It has a generic `viewModel` property and a `controllerModel` property.
 The ViewModel can be specify as generic type. In the example the `ExampleViewController` has a viewModel property from type `ExampleViewModel *`.

The implementation of a custom ViewController is pretty straight forward like a custom ViewModel:

```obj-c
@interface ExampleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *someNoLabel;
@end

@implementation ExampleViewController

- (VMKBindingDictionary *)viewModelBindings {
    return @{
        VMK_BINDING_PROPERTY(name),
        VMK_BINDING_PROPERTY(seomNo)
    };
}

#pragma mark - binding did changed

- (void)nameDidChanged {
    self.nameLabel.text = self.viewModel.name;
}

- (void)someNoDidChanged {
    self.someNoLabel.text = [[NSString alloc] initWithFormat:@"%d", (int)self.viewModel.someNo];
}

@end
```

The `VMKViewController` life cycle `viewWillAppear` method is calling the `bindViewModel` method which is using the `viewModelBindings` method to get the bindings.
At `viewWillDisappear` the `unbindViewModel` method gets called and disconntect the view model from the view controller.

To use the `ExampleViewController` it will be instanciate from a previous view controller (or storyborad) and a setup (for example `prepareForSegue:forSender:` method) sets the view model on it.

### Use CoreData ManagedObject in ViewModels

The view model class `VMKCoreDataViewModel` allows any `NSManagedObject` as model object.

```obj-c
@interface YourCoreDataViewModel : VMKCoreDataViewModel<YourCoreData *>
@end
```

It uses the same methods as any normal `VMKViewModel` class.

### VMKTableViewController or VMKCollectionViewController

The `VMKTableViewController` and `VMKCollectionViewController` are similar to `VMKViewController` but they add additional functionality and use a data source to handle cell view models easier.

On the first glance a table view with a table view controller seems to make it more complex but it uses the same principles you have seen already with `VMKViewModel` and `VMKViewController`.

A full setup needs a custom `VMKTableViewController` with a custom `VMKViewModel` from type `VMKDataSourceViewModelType`.  The `VMKDataSourceViewModelType` is a protocol and adds a data source to the view model.

The `VMKTableViewController` and `VMKCollectionViewController` are working with a `VMKDataSource` and that is the second part of the setup. The typical data sources are already implemented but it can be customized by implementing an own data source.

Every cell in a table view or cellection view has a cell view model. The `VMKDataSource` is creating `VMKViewModel` from type `VMKCellType` for the requested cell. These cell view models are the view models for the cells like a `VMKViewModel` is for the `VMKViewController`.

#### Create a VMKTableViewController

The `VMKTableViewController` can customize the view related part with the `VMKTableViewDataSourceDelegate`. The view models are not defining any view related parts like what kind of cell.

```obj-c
@implementation TableViewController (VMKTableViewDataSourceDelegate)

- (NSString *)dataSource:(VMKTableViewDataSource *)dataSource cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {

    // VMKViewModel<VMKCellType> *vm = [dataSource viewModelAtIndexPath:indexPath];
    return @"CustomCell";
}

@end
```

It is possible to interact with the cell view model to get the right cell identifier.

There are some more methods in the `VMKTableViewDataSourceDelegate` that allow you to customize the table view behaivor and they are quite similar to the `UITableViewDataSource`.

Some of the `UITableViewDelegate` methods are get passed to the `VMKTableViewController`. The others are already handled.

#### Create a Table View Model

The view model for the `VMKTableViewController` or the `VMKCollectionViewController` have one important method to implement: the `dataSource` getter.

```obj-c
@implementation TableViewModel (VMKDataSourceViewModelType)

- (VMKDataSource *)dataSource {
    if (!_dataSource) {
        NSArray<VMKViewModel<VMKCellType> *> *viewModels = [self getViewNodels];
        _dataSource = [[VMKArrayDataSource alloc] initWithViewModels:viewModels];
    }
    return _dataSource;
}

@end
```

There are several data source possiblities.  The typical data soucres like an array, a mutable array or a fetched resultscontroller data source are available to use immediately without subclassing. They called data source provider because they providing cell view models.

It is also possible to write your own data source provider by subclassing the `VMKDataSource`.

#### Create a ViewModel for a Cell

The cell view model is any `VMKViewModel` that conforms to the `VMKCellType` protocol. These cell view models are the view models for any cells. The corresponding views are `VMKTableViewCell`, `VMKCollectionViewCell` or their subclasses. They are observing the cell view models to display any data like the other `VMKViewModel`.

In the example the cell view model has a core data entity `SomeData` and uses the `VMKCoreDataViewModel` as basis class. It conforms to the `VMKCellType` to be a cell view model.

```obj-c
@interface CellViewModel : VMKCoreDataViewModel<SomeData *> <VMKCellType>
@end
```

The private header declares the necessary properties to readwrite. Usually only the `viewModel` property is necessary for a cell view model, because this is the view model for the detail view controller.

For a default `UITableViewCell` the property `title`, `subtitle` and `image` can be implemented without having a custom cell view. Here, in the example the `image` is not used.

```obj-c
@interface CellViewModel ()
// protocol VMKCellViewModelType optional
@property (nonatomic, copy, readwrite, nullable) NSString *title;
@property (nonatomic, copy, readwrite, nullable) NSString *subtitle;
// protocol VMKCellViewModelType
@property (nonatomic, weak, readwrite, nullable) VMKViewModel *viewModel;
@end
```

The implementation does the binding.

```obj-c
@implementation CellViewModel

#pragma mark - binding

- (VMKBindingDictionary *)modelBindings {
    return @{
        VMK_BINDING_KEYPATH_PROPERTY(@"title", title),
        VMK_BINDING_KEYPATH_PROPERTY(@"subtitle", subtitle)
    }
}

- (void)titleDidChange {
    self.title = self.model.title;
}

- (void)subtitleDidChange {
    self.subtitle = self.model.subtitle;
}

#pragma mark - VMKCellType

- (VMKViewModel *)viewModel {
    if (_viewModel) {
        return _viewModel;
    }

    // the _viewModel is weak therefore use a strong heap varaiable
    DetailViewModel *dvm = [[DetailViewModel alloc] initWithModel:self.model];
    _viewModel = dvm;
    return dvm;
}
```

The implementation is using the same structure like any other view model. The `viewModel` is only needed if there is a detail view controller to present from the cell. This `viewModel` gets passed to the detail view controller.

## Architecture

The Framework is divided into several sections. The sections are:

- `Observer`
- `Model`
- `CellViewModel`
- `ViewController`
- `DataSource`
- `CoreData`
- `ChangeSet`
- `Controller`
- `UIKit Views`

### Observer

The Observer section encapsulate the KVO in two classes and two managers. The classes are

- `VMKObservable`
- `VMKBindingUpdater`
- `VMKObservableManager`
- `VMKObservableNotificationManager`

The `VMKObservable` holds the object, the keypath and an observer to inform about updates. The `VMKObservable` and `VMKBindingUpdater` are the heart of the `ViewModelKit`. They can be used standalone to do bindings between any model object and any observer.

The `VMKBindingUpdater` holds the observer as a weak property to avoid retain cycle and let the observer deallocate. The class checks if the observer is gone before calling the update method. So KVO will not crash if the observer is already deallocated.

The `VMKObservableManager` manages all instances of `VMKObservables`. An instance of this class holds the observables and deallocate everything on deallocation. It manages the bindings between any object, keypath and observers. Every `VMKViewModel` has its own ``VMKObserverManager`. One reason is if any view model will be released the bindings will be disconnected immediately.

The `VMKObservableNotificationManager` is inside the Observer section but is has nothing to do with the KVO observing. It is a helper class for `NSNotification` that uses blocks.

### Model

The Model section groups the basic view model classes and model related protocols together.

- `VMKViewModel`
- `VMKControllerModel`
- `VMKArrayModel`
- `VMKDataSourceViewModelType`
- `VMKEditingType`
- `VMKImageEditingType`
- `VMKViewModelCache`

The `VMKViewModel` is the basis class of any view model and takes care of the binding mechanism. It has two observable managers. One is internally for the view model itself and primarily aviable for subclassing.
The other is for the external bindings. There is a interface with several methods to bind any observer to the view model. This is mostly used from view controllers. Subclasses normally only write the `modelBindings` method.
The `bindModel` and `unbindModel` are get called during the `setModel` method or from `startModelObservation`. The init is not starting any observation even if a model is passed as argument.

The `VMKControllerModel` is used inside a view controller to pass view related settings around. For example to change the index path of the selected cell from a detail view controller. Or set the next view controller into an edit mode.

The `VMKArrayModel` observes an given array. Use the interface to generate KVO changes for the different operation.

The `VMKDataSourceViewModelType` is declaring a data source and they are used for a table view controller or collection view controller.

The `VMKEditingType` and `VMKImageEditingType` are used to specify that a view model can be edited or have an image that can be edited. There are some other controller model implementations that are using the types.

The `VMKViewModelCache` is a caching class for view model. The class is used for data source provider to reuse view models.

### CellViewModel

The CellViewModel section is releated to cell view model that can be used for the `UITableViewCell` or `UICollectionViewCell`.

- `VMKCellType`
- `VMKViewCellType`
- `VMKHeaderFooterType`
- `VMKViewHeaderFooterType`
- `VMKCellViewModelFactory`
- `VMKInsertCellViewModel`

The `VMKCellType` is used for any cell view model and define several mostly optional methods. The only non optional method is the `viewModel` getter. This view model is used for any detail view for that specific cell. Beside that the three getters for `title`, `subtitle` and `image` can be implemented in conjunction with `UITableViewCell` or `UICollectionViewCell`.
A custom cell may use them or define different ones. Several methods are used to indicate any editing possiblitites like `canEdit` or `canDelete`.

The `VMKViewCellType` is a type for any `UITableViewCell` or `UICollectionViewCell`  that can be used with the `ViewModelKit`.  Any custom view cell class must be conform to this protocol. The generic `VMKTableViewCell` and `VMKCollectionViewCell` do it.

The `VMKHeaderFooterType` and `VMKViewHeaderFooterType` are analog to the cell ones. They are defining the view model and the  `UITableViewHeaderFooterView` for `ViewModelKit`.

The `VMKCellViewModelFactory` protocol describes how to create a cell view model from a data source with an object. It is used for some data source provider to delegate this task back to a view model.

The `VMKInsertCellViewModel` is a cell view model for a cell that can insert new data. It is a static cell.

### ViewController

The ViewController section has three view controllers.

- `VMKViewController`
- `VMKTableViewController`
- `VMKCollectionViewController`

The `VMKViewController` can be used as typical view controller. It has the bin and unbind during the view life cycle process integrated. In addition to a `viewModel`property it has a `controllerModel` property. Also the view controller is able to show an alert controller and a choose image controller immediately.  A subclass should provide the type of the view model and overwrite the `viewModelBindings`.`

The `VMKTableViewController` and `VMKCollectionViewController` are similar to the `VMKViewController` but have in addition implemented the delegate and necessary data source protocol methods. For example will a table view update all changes from the data source lively via row animations.
The view controllers are using several wrapper classes to combine the delegate and data source protocol from `UIKit` properly with the `ViewModelKit`.

If you cannot use one of the three view controller classes them you have to write the binding and have to conform to the view model protocols by yourself. The implementation of the classes can give you usefull information how to do.

### DataSource

The DataSource section has classes to abstract the data source for `UITableView` or `UICollectionView`. Both have the same data source interface and uses cell view models.

The section is divided into four subsection Abstract, Provider, Multi and Grouped data sources.

#### Abstract DataSources

- `VMKDataSource`
- `VMKDataSourceDelegate`
- `VMKDataSourceType`

The `VMKDataSource` is the abstract class of all data source classes. It provides a `delegate` property and an `editing` property. There are some inserting and deleting row methods and the reordering methods. These information will be obtained from the cell view model.

The `VMKDataSourceDelegate` is the reporting system to notify an object about a change. It uses the `VMKChangeSet`. Subclasses of  `VMKDataSource` can implement this protocol to catch changes from lower data sources to manipluate the changes.

The `VMKDataSourceType` is basis of any data source for the `ViewModelKit`. It defines three must have methods. Every `VMKDataSourceType` must implement `sections`, `rowsInSection:` and `viewModelAtIndexPath:`. Then it defines several section header, section footer and section index methods a la `UITableViewDataSource`. The `setEditing` is optional.

#### Provider DataSources

- `VMKArrayDataSource`
- `VMKMutableArrayDataSource`
- `VMKFetchedDataSource`

The `VMKArrayDataSource` uses an array of cell view models and provide them. This data source is static and no change set will be send. It can have a header view model as a section header.

The `VMKMutableArrayDataSource` uses an `VMKArrayModel` which contains any model objects. The model object will be converted into cell view model by the `VMKCellViewModelFactory` delegate. These cell view model are cached with the `VMKViewModelCache`. Everytime the `VMKArrayModel` has changed the `VMKArrayUpdater` get informed and generate a change set.

The `VMKFetchedDataSource` uses a `NSFetchedResultsController` to get the models from core data. A `VMKCellViewModelFactory` delegate creates the cell view model. Some settings allow to configure the data source. The changes will be reported similar like `VMKMutableArrayDataSource` does it.

#### Multi DataSources

The multi data sources are used to build up a tree of data sources. The provider data source are the leaves of the tree the trunk or branches can be any multi data source.

There are two general multi data sources. On divide the data source into sections and the other are rows. Both can add or remove a data source at runtime. Also insert a data source at an index or remove it at an index.

The `VMKMultiSectionDataSource` can have several data sources. Every data source are handled as part of sections. For example the first data source has 2 sections and the second one has 4 sections. Then the multi data source will return 6 section. Every access at section 0 to 1 will be routed to the first data source. Every access to the section 2 to 5 will be mapped to 0 to 3 and then routed to the second data source.

The `VMKMultiRowDataSource` can have also several data sources. Every data source are handled as part of rows. It is complete similar to the `VMKMultiSectionDataSource` except it uses rows.

The `VMKEditDataSource` is specialized multi data source that has two data sources. In edit mode the edit data source is shown. There is a mode add the edit data source as  rows or sections.

#### Grouped DataSources

The `VMKGroupedDataSource` is specialized data source that has one data source to get the grouped keys of a set of objects. Then it uses the grouped key to cluster several objects together and generate only one data source of each grouped key.

### CoreData

The CoreData section has three classes.

- `VMKCoreDataViewModel`
- `VMKChangeWatcher`
- `VMKDeleteWatcher`

The `VMKCoreDataViewModel` is a view model class for `NSManagedObject`. It has three additional method for editing and saving. This might be changing in the future.

The `VMKChangeWatcher` is a class that informs a delegate if any core data object has changed. The class is managing which object will be observed.

The `VMKDeleteWatcher` is a class that informs a delegate if any core data object has deleted. The class is managing which object will be observed.

### ChangeSet

The ChangeSet section has two classes related to a change set and two classes that emit a change set.

- `VMKChangeSet`
- `VMKSingleChange`
- `VMKArrayUpdater`
- `VMKFetchedUpdater`

The `VMKChangeSet` object is used to take all changes in the view models through the data source into the view controller. The change set itself has the changes of any collection of view models. The changes are distinct between section and row changes. The row changes are inserted, deleted, updated and moved. The section changes are inserted, deleted and updated.
If for example a fetched resultscontroller got changes from core data every single change will be recorded and stored in the history of a change set. This change set will be transmitted through the data source to the `VMKTableViewController` or `VMKCollectionViewController`. The controller itself replay all changes into row anmination.

The `VMKSingleChange` is one specific change. The type of the change is a `VMKSingleChangeType`. The class has several convinence getter and a method to manipulate the offsets.

The `VMKArrayUpdater`  takes a `VMKArrayModel` and observes all changes in the array. The changes will be recorded and send as `VMKChangeSet` to a delegate.

The `VMKFetchedUpdater`  is a `NSFetchedResultsControllerDelegate` and observes all changes in the fetch request of the fetched result controller. The changes will be recorded and send as `VMKChangeSet` to a delegate.

### Controller

The Controller section has two system controllers and related view models.

- `VMKAlertController`
- `VMKAlertViewModel`
- `VMKChooseImageController`
- `VMKChooseImageViewModel`

The `VMKAlertController` is the `UIAlertController` that uses the `VMKAlertViewModel`. The three view controllers have already a `VMKAlertController` and can show immediately one.

The `VMKAlertViewModel` configures the alert view controller.

The `VMKChooseImageController` is the `UIImagePickerController` that uses the `VMKChooseImageViewModel`. The three view controllers have already a `VMKChooseImageController` and can show immediately one.

The `VMKChooseImageViewModel` configures the image picker controller.

## Running the tests

The tests are using OCHamcrest and OCMockito. Both frameworks can be installed through Carthage.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/Andrenalin/ViewModelKit/tags).

## Authors

* **Andre Trettin** - *Creator* - [Andrenalin](https://github.com/Andrenalin)
* **Daniel Rinser** - *CollectionView* - [danielr](https://github.com/danielr)
* **Daniel Seebach** - *TableHeaderFooter* - [DanielSeebach](https://github.com/DanielSeebach)

See also the list of [contributors](https://github.com/Andrenalin/ViewModelKit/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

