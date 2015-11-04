//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* businesses;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.tableView.estimatedRowHeight = 2.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.businesses = [[NSMutableArray alloc] init];
    
    self.title = @"iSearch";
    
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    self.navigationItem.titleView = searchBar;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];

    [YelpBusiness searchWithTerm:@"Restaurants"
                        sortMode:YelpSortModeBestMatched
                      categories:@[@"burgers"]
                           deals:NO
                      completion:^(NSArray *businesses, NSError *error) {
                          for (YelpBusiness *business in businesses) {
                            NSLog(@"%@", business);
                            [self.businesses addObject:business];
                          }
                          
                          [self.tableView reloadData];
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    
    cell.business = self.businesses[indexPath.row];
    
    return cell;
}

#pragma mark - private methods

- (void)onFilterButton {
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Filter delegate methods

- (void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *) filters {
    NSLog(@"Called delegate method");
}

@end
