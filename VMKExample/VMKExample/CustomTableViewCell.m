//
//  CustomTableViewCell.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "CustomTableViewCell.h"

#import "TableCellViewModel.h"

@interface CustomTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation CustomTableViewCell

#pragma mark - bindings

- (VMKBindingDictionary *)viewModelBindings {
    return @{ VMK_BINDING_PROPERTY(name),
              VMK_BINDING_PROPERTY(price),
              VMK_BINDING_PROPERTY(amount),
              VMK_BINDING_KEYPATH_PROPERTY(@"selected", selected)
             };
}

- (void)nameDidChange {
    self.nameLabel.text = self.viewModel.name;
}

- (void)priceDidChange {
    self.priceLabel.text = self.viewModel.price;
}

- (void)amountDidChange {
    self.amountLabel.text = self.viewModel.amount;
}

- (void)selectedDidChange {
    NSLog(@"Changed");
}

@end
