//
//  ViewController.m
//  VMKExample
//
//  Created by Andre Trettin on 17.07.16.
//  Copyright © 2016 Andre Trettin. All rights reserved.
//

#import "ViewController.h"
#import "VenueModel.h"
#import "TableViewController.h"
#import "TableViewModel.h"
#import "CollectionViewController.h"
#import "CollectionViewModel.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueIdLabel;

@property (nonatomic, strong) VenueModel *venueModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.venueModel = [[VenueModel alloc] init];
    self.viewModel = [[VenueViewModel alloc] initWithModel:self.venueModel];
    [self.viewModel startModelObservation];
}

#pragma mark - bindings

- (VMKBindingDictionary *)viewModelBindings {
    return @{
             NSStringFromSelector(@selector(name)):
                 [self bindingUpdaterOnSelector:@selector(nameDidChanged)],
             NSStringFromSelector(@selector(venueId)):
                 [self bindingUpdaterOnSelector:@selector(venueIdDidChanged)]
             };
}

#pragma mark - binding did changed

- (void)nameDidChanged {
    self.nameLabel.text = self.viewModel.name;
}

- (void)venueIdDidChanged {
    self.venueIdLabel.text = [[NSString alloc] initWithFormat:@"%d", (int)self.viewModel.venueId];
}

#pragma mark - user action

- (IBAction)tappedChangedModel:(UIButton *)sender {
    static NSInteger i = 1;
    
    self.venueModel.name = [[NSString alloc] initWithFormat:@"%d. name generated", (int)i];

    self.venueModel.venueId = @(i);
    i++;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VMKViewController *vmkVC = segue.destinationViewController;
    
    if ([vmkVC isKindOfClass:[TableViewController class]]) {
        vmkVC.viewModel = [[TableViewModel alloc] init];
    }
    else if ([vmkVC isKindOfClass:[CollectionViewController class]]) {
        vmkVC.viewModel = [[CollectionViewModel alloc] init];
    }
}

@end
