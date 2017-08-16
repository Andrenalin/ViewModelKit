//
//  TableDetailViewController.m
//  VMKExample
//
//  Created by Andre Trettin on 25/10/2016.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "TableDetailViewController.h"

#import "TableDetailViewModel.h"

@interface TableDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end


@implementation TableDetailViewController

#pragma mark - binding

- (VMKBindingDictionary *)viewModelBindings {
    
    return @{ VMK_BINDING_PROPERTY(name),
              VMK_BINDING_PROPERTY(amount),
              VMK_BINDING_PROPERTY(price),
             };
}

#pragma mark - binding did changed

- (void)nameDidChange {
    self.nameLabel.text = self.viewModel.name;
}

- (void)priceDidChange {
    self.priceLabel.text = self.viewModel.price;
}

- (void)amountDidChange {
    self.amountLabel.text = self.viewModel.amount;
}

@end
