//
//  TableViewController.m
//  VMKExample
//
//  Created by Andre Trettin on 07/02/2017.
//  Copyright © 2017 Andre Trettin. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewModel.h"

@interface TableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopBarButtonItem;
@end

@implementation TableViewController

- (VMKBindingDictionary *)viewModelBindings {
    return @{
             TableViewModel.runningKeyPath:
             [self bindingUpdaterOnSelector:@selector(runningDidChange)]
            };
}

- (void)runningDidChange {
    self.playBarButtonItem.enabled = !self.viewModel.running;
    self.stopBarButtonItem.enabled = self.viewModel.running;
}

- (IBAction)tappedPlayBarButtonItem:(UIBarButtonItem *)sender {
    [self.viewModel start];
}

- (IBAction)tappedStopBarButtonItem:(UIBarButtonItem *)sender {
    [self.viewModel stop];
}

@end
