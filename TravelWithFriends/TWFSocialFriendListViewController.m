//
//  TWFSocialFriendListViewController.m
//  TravelWithFriends
//
//  Created by Justin Warmkessel on 3/5/13.
//  Copyright (c) 2013 Justin Warmkessel. All rights reserved.
//

#import "TWFSocialFriendListViewController.h"
#import "TWFSocialFriend.h"
#import <QuartzCore/QuartzCore.h>

@interface TWFSocialFriendListViewController ()

@end

@implementation TWFSocialFriendListViewController
@synthesize socialFriendList = _socialFriendList, filteredFriendArray = _filteredFriendArray;

- (id)initWithFriendsList:(NSMutableArray *)socialFriendList {
    if (self) {
        _socialFriendList = socialFriendList;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"socialFriendList arg %lu", (unsigned long)[self.socialFriendList count]);

    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    NSLog(@"socialFriendlist count %lu", (unsigned long)_socialFriendList.count);
    self.filteredFriendArray = [NSMutableArray arrayWithCapacity:[_socialFriendList count]];
    

    UISearchBar * theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,40)]; // frame has no effect.
    theSearchBar.delegate = self;
    //    if ( !searchBarPlaceHolder ) {
    //        searchBarPlaceHolder = @"What are you looking for?";
    //    }
    theSearchBar.placeholder = @"blah";
    theSearchBar.showsCancelButton = YES;
    
    
    self.tableView.tableHeaderView = theSearchBar;
    
    [self.searchDisplayController setActive:YES animated:YES];
    [theSearchBar becomeFirstResponder];
    
    UISearchDisplayController *searchCon = [[UISearchDisplayController alloc]
                                            initWithSearchBar:theSearchBar
                                            contentsController:self ];
    self.searchDisplayContr = searchCon;
    [searchCon release];
    self.searchDisplayContr.delegate = self;
    self.searchDisplayContr.searchResultsDataSource = self;
    self.searchDisplayContr.searchResultsDelegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger theCount;
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        theCount = self.filteredFriendArray.count;
    } else {
        theCount = _socialFriendList.count;
    }
    return theCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *nameTxt = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 320.0f, 35.0f)];
        [cell addSubview:nameTxt];
        [nameTxt setTag:1];
    }
   
    TWFSocialFriend *friend;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [self.filteredFriendArray objectAtIndex:indexPath.row];
    } else {
        friend = [self.socialFriendList objectAtIndex:indexPath.row];
    }

    // Configure the cell
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = friend.firstName;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - UISearchBarDelegate UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"shouldReloadTableForSearchString");
    // Tells the table data source to reload when text changes

    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayContr.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayContr.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
    
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"shouldReloadTableForSearchScope");
    // Tells the table data source to reload when scope bar selection changes

    [self filterContentForSearchText:self.searchDisplayContr.searchBar.text scope:
     [[self.searchDisplayContr.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"searchDisplayControllerDidBeginSearch");
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredFriendArray removeAllObjects];
    
    for (TWFSocialFriend *friend in _socialFriendList)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"(SELF contains[cd] %@)", searchText];
        [friend.firstName compare:searchText options:NSCaseInsensitiveSearch];

        BOOL resultName = [predicate evaluateWithObject:friend.firstName];
        
        if(resultName)
        {
            [self.filteredFriendArray addObject:friend];
        }
    }

    NSLog(@" new filtered array count %lu", (long int)[self.filteredFriendArray count]);
}


@end
