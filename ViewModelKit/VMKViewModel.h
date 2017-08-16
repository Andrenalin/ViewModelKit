//
//  VMKViewModel.h
//  ViewModelKit
//
//  Created by Andre Trettin on 06.12.15.
//  Copyright © 2015 Andre Trettin. All rights reserved.
//

@import Foundation;

#import "VMKMacros.h"
#import "VMKObservableManager.h"

NS_ASSUME_NONNULL_BEGIN


/**
 @brief The ViewModel class is the generic class for any ViewModel.
 
 It provides an internal interface for any inherited specialised ViewModel to bind itself
 to a model object.
 The second public interface is for controlls who owns the view model typically.
 
 Any inherited class from ViewModel can use the observableManager to create binding
 between the own model object and their properties. The bindingUpdaterOnSelector method
 can help to do the bindings directly to the ViewModel.
 
 Any owner of the ViewModel shall use the bind and unbind methods of the class. But shall not
 use the observableManager property and the bindingUpdaterOnSelector method.
 */
@interface VMKViewModel<__covariant ObjectType> : NSObject

#pragma mark - inheritance interface

/// The model instance to bind the view model on it.
@property (nonatomic, strong, nullable) ObjectType model;

/// The observable manager to manage internally the bindings to any model objects.
@property (nonatomic, strong, readonly) VMKObservableManager *observableManager;

/// The bindings to the model object in a shortend version as dictionary.
@property (nonatomic, strong, readonly) VMKBindingDictionary *modelBindings;

/// A flag whether the model will be observe or not.
@property (nonatomic, assign, readonly, getter=isObservingModel) BOOL observingModel;


/**
 @brief Instanciate a new view model object with a model object.
 
 Use this initializer to set immediately the model object. If you have multiple model for
 one view model the sub class has to take care to handle it. If the model is not set
 the bind and unbind meethods will not be called.

 @param model The model that will be observed and converted into this view model.
 @return Instance of a VMKViewModel.
 */
- (instancetype)initWithModel:(nullable ObjectType)model;

/**
 @brief Unbinds the model from the view mnodel observer.
 
 Overwrite this method if you want custom unbindiing or other behaivor during the unbind process.
 You don't have to call the super method.
 */
- (void)unbindModel;

/**
 @brief Binds the model to the view mnodel observer.
 
 Overwrite this method if you want custom bindiing or other behaivor during the bind process.
 You don't have to call the super method. 
 
 The bindModel is using the modelBindings dictionary to bind the properties to the DidChange methods.
 
 Normally overwrite the modelBindings to get the necessary customization is enough.
 */
- (void)bindModel;

/**
 @brief Returns a bindingUpdater instance with an updateAction to itself.

 @param updateAction A method on the ViewModel that is called on update.
 @return A BindingUpdater instance to use with the observableManager.
 */
- (VMKBindingUpdater *)bindingUpdaterOnSelector:(SEL)updateAction;

#pragma mark - interface for the view controllers / controllers / owner of the view model

/**
 @brief Starts the observation of the model.
 
 This methos must be called if the model is set through the init to start the observer.
 Otherwise the view model properties will not be updated. If the model will be set by the
 setter method setModel it is not necessary to call this method. The observer will
 automatically observe.
 */
- (void)startModelObservation;

- (void)bindBindingDictionary:(VMKBindingDictionary *)bindingDictionary;
- (void)bindUpdater:(VMKBindingUpdater *)bindingUpdater toKeyPath:(NSString *)keyPath;
- (void)bindObject:(id)object updateAction:(SEL)updateAction toKeyPath:(NSString *)keyPath;

- (void)unbindKeyPath:(NSString *)keyPath;
- (void)unbindObserver:(id)observer;
- (void)unbindObserver:(id)observer fromKeyPath:(NSString *)keyPath;

- (void)unbindAllConnections;
@end

NS_ASSUME_NONNULL_END
