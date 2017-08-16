//
//  CustomCollectionViewCell.m
//  VMKExample
//
//  Created by Daniel Rinser on 09.11.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "CollectionCellViewModel.h"

@interface CustomCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@end

@implementation CustomCollectionViewCell

#pragma mark - bindings

- (VMKBindingDictionary *)viewModelBindings {
    return @{ VMK_BINDING_PROPERTY(title),
              VMK_BINDING_PROPERTY(subtitle)
              };
}

#pragma mark - bindings did change

- (void)titleDidChange {
    self.label1.text = self.viewModel.title;
}

- (void)subtitleDidChange {
    self.label2.text = self.viewModel.subtitle;
}

@end
