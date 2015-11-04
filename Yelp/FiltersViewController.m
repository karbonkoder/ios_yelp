//
//  FiltersViewController.m
//  Yelp
//
//  Created by Ankush Raina on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dealsTableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSDictionary *sections;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

@end

@implementation FiltersViewController

//- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    
//    if (self) {
//        self.selectedCategories = [NSMutableSet set];
//        [self initCategories];
//    }
//    
//    return self;
//}

- (id) init {
    self = [super init];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];
    
    self.dealsTableView.delegate = self;
    self.dealsTableView.dataSource = self;
    
    [self.dealsTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[[self.sections allKeys][section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];

    NSString *section = [self.sections allKeys][indexPath.section];
    cell.cellTitleLabel.text = self.sections[section][indexPath.row];
    //self.categories[indexPath.section][indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections allKeys][section];
}

# pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.dealsTableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - Private methods

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSearchButton {
    // TODO process current app state and compute filters so it's passed properly
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initCategories {
    // category, sort (best match, distance, highest rated), distance, deals (on/off)
    //Offering a Deal
    //
    //Distance
    //Auto
    //0.3 miles
    //1 mile
    //5 mile
    //20 mile
    //
    //Sort By
    //Best Match
    //Distance
    //Highest Rated
    //
    //Category
    //Afghan
    //African
    //American New
    //See All
    
    self.sections =
    @{ @"Deal" : @[@"Offering a Deal"],
       @"Distance" : @[@"Auto", @"0.3 miles", @"1 mile", @"5 miles"],
       @"Category" : @[@"Afgan", @"African", @"American (New)", @"American (Traditional)"],
       @"Sort By" : @[@"Best Match", @"Distance", @"Highest Rated"]};
    
    self.categories =
        @[@{@"name" : @"Afgan", @"code" : @"afgani"},
          @{@"name" : @"African", @"code" : @"african"},
          @{@"name" : @"American, New", @"code" : @"newamerican"},
          @{@"name" : @"American, Traditional", @"code" : @"tradamerican"}
        ];
}

@end
