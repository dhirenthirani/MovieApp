//
//  HomeViewController.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "HomeViewController.h"
#import "GetMovieList.h"
#import "Constants.h"
#import "MovieDetailViewController.h"
#import "MovieTableViewCell.h"
#import "UILoaderTableViewCell.h"
#import "SearchMovieObject.h"
#import "SearchTableViewCell.h"

@interface HomeViewController () <GetMovieListDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SearchMovieDelegate>

@property (nonatomic) BOOL isEditing;
@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) SearchMovieObject *searchObject;

@property (nonatomic, strong) GetMovieList *getMoviesList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForNotification];
    
    self.isEditing = NO;
    self.searchString = @"";
    
    [self createHeader];
    [self createSearchBar];
    [self createTableView];
    
    [self initialiseApiWrapper];
    
    [self getMovieList];
}

#pragma mark ResgisterForNotification
- (void)registerForNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, rect.size.height, 0)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.tableView setContentInset:UIEdgeInsetsZero];
}

- (void)createHeader {
    [self.navigationItem setTitle:@"Movies"];
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, [Constants navigationBarHeight], W(self.view), 50)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Search For Movies"];
    [self.view addSubview:self.searchBar];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BOTTOM(self.searchBar), W(self.view), H(self.view) - BOTTOM(self.searchBar)) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEditing) {
        if (self.searchString.length > 0) {
            if (self.searchObject.moviesArray.count > 0) {
                if (self.searchObject.moviesArray.count < self.searchObject.totalResult.integerValue) {
                    return self.searchObject.moviesArray.count + 1;
                }
                else {
                    return self.searchObject.moviesArray.count;
                }
            }
            else {
                return 1;
            }
        }
    }
    else {
        if (self.getMoviesList.moviesArray.count > 0) {
            if (self.getMoviesList.moviesArray.count < self.getMoviesList.totalResult.integerValue) {
                return self.getMoviesList.moviesArray.count + 1;
            }
            else {
                return self.getMoviesList.moviesArray.count;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        if (indexPath.row < self.searchObject.moviesArray.count) {
            //label height
            Movie *movie = [self.searchObject.moviesArray objectAtIndex:indexPath.row];
            return [SearchTableViewCell getHeight:movie.name];
        }
        else if (self.searchObject.isLoading && indexPath.row >= self.searchObject.moviesArray.count) {
            return 50;
        }
        else if (self.searchString.length > 0 && self.searchObject.moviesArray.count == 0 && !self.searchObject.isLoading) {
            //emptyString Height
            return [SearchTableViewCell getHeight:@"No Result Found"];
        }
    }
    else {
        if (indexPath.row >= self.getMoviesList.moviesArray.count && self.getMoviesList.moviesArray.count < self.getMoviesList.totalResult.integerValue) {
            return 100;
        }
        else {
            Movie *movie = [self.getMoviesList.moviesArray objectAtIndex:indexPath.row];
            return [MovieTableViewCell getHeightForMovie:movie];
        }
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        if (indexPath.row < self.searchObject.moviesArray.count) {
            SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
            if (!cell) {
                cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
            }
            Movie *movie = [self.searchObject.moviesArray objectAtIndex:indexPath.row];
            [cell setName:movie.name];
            return cell;
        }
        else if (self.searchObject.isLoading && indexPath.row >= self.searchObject.moviesArray.count) {
            UILoaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoaderCell"];
            if (!cell) {
                cell = [[UILoaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoaderCell"];
            }
            return cell;
        }
        else if (self.searchString.length > 0 && self.searchObject.moviesArray.count == 0 && !self.searchObject.isLoading) {
            SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
            if (!cell) {
                cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            }
            [cell setName:@"No Result Found"];
            [cell.titleLabel setTextColor:[UIColor darkGrayColor]];
            return cell;
        }
    }
    else {
        if (indexPath.row >= self.getMoviesList.moviesArray.count && self.getMoviesList.moviesArray.count < self.getMoviesList.totalResult.integerValue) {
            UILoaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoaderCell"];
            if (!cell) {
                cell = [[UILoaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoaderCell"];
            }
            return cell;
        }
        else {
            Movie *movie = [self.getMoviesList.moviesArray objectAtIndex:indexPath.row];
            
            MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
            if (!cell) {
                cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MovieCell"];
            }
            [cell setData:movie];
            return cell;
        }
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        if (indexPath.row < self.searchObject.moviesArray.count) {
            Movie *movie = [self.searchObject.moviesArray objectAtIndex:indexPath.row];
            [self showDetailScreenForMovie:movie];
        }
    }
    else {
        if (indexPath.row < self.getMoviesList.moviesArray.count) {
            Movie *movie = [self.getMoviesList.moviesArray objectAtIndex:indexPath.row];
            [self showDetailScreenForMovie:movie];
        }
    }
}

- (void)showDetailScreenForMovie:(Movie *)movie {
    MovieDetailViewController *movieDetailVC = [[MovieDetailViewController alloc] init];
    [self.navigationController pushViewController:movieDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        if ([cell isKindOfClass:[UILoaderTableViewCell class]]) {
            [self loadMoreSearchList];
        }
    }
    else {
        if ([cell isKindOfClass:[UILoaderTableViewCell class]]) {
            [self loadMoreMovieList];
        }
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.isEditing = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.tableView reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isEditing = NO;
    self.searchString = nil;
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    [self.searchObject getMovieListForSearchString:self.searchString];
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isEditing = YES;
    self.searchString = searchText;
    
    [self.searchObject getMovieListForSearchString:self.searchString];
    [self.tableView reloadData];
}

- (void)initialiseApiWrapper {
    self.getMoviesList = [[GetMovieList alloc] init];
    [self.getMoviesList setDelegate:self];
    
    self.searchObject = [[SearchMovieObject alloc] init];
    [self.searchObject setDelegate:self];
}

- (void)getMovieList {
    [self showLoader];
    [self.getMoviesList getMovieList];
}

- (void)loadMoreMovieList {
    if (!self.getMoviesList.isLoading) {
        [self.getMoviesList loadMoreResults];
    }
}

#pragma mark GetMovieList
- (void)movieListFetchedSuccessfully {
    [self hideEmptyViewAndLoader];
    [self.tableView reloadData];
}

- (void)movieListFetchingFailedWithError:(NSError *)error {
    [self hideEmptyViewAndLoader];
    if (!(self.getMoviesList.moviesArray.count > 0)) {
        [self showEmptyView];
    }
}

- (void)loadMoreSearchList {
    [self.searchObject loadMoreResults];
}

#pragma mark SearchMovieObject
- (void)movieSearchedSuccessfully {
    [self.tableView reloadData];
}

- (void)movieSearchFailedWithError:(NSError *)error {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end