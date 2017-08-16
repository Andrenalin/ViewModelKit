//
//  VMKMacros.h
//  ViewModelKit
//
//  Created by Andre Trettin on 09.08.17.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//


#define VMK_NAME_DID_CHANGE(name) name##DidChange

#define VMK_BINDING_PROPERTY(name) NSStringFromSelector(@selector(name)): [self bindingUpdaterOnSelector:@selector(VMK_NAME_DID_CHANGE(name))]

#define VMK_BINDING_KEYPATH_PROPERTY(keypath, name) keypath: [self bindingUpdaterOnSelector:@selector(VMK_NAME_DID_CHANGE(name))]
