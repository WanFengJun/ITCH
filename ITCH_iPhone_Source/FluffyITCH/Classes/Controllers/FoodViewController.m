//
//  FoodViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "FoodViewController.h"
#import "ITCHAppDelegate.h"
#import "FoodTableViewCell.h"
#import "Food.h"
#import "Dog.h"
#import "JSON.h"
#import "Utils.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"

@interface FoodViewController ()

@end

@implementation FoodViewController

@synthesize dog, usedFoodList;
@synthesize mTableView, mAutoCompleteTableView, lblDogName, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lblDogName.text = [NSString stringWithFormat:@"%@\' Food", dog.name];
    
    autoCompleteList = [NSMutableArray new];
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    fullFoodList = appDelegate.fullFoodList;
    
    [self loadFoodList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFoodList
{
    self.usedFoodList = [NSMutableArray new];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_USED_FOOD_LIST_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        
        NSArray *foodDicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(foodDicList == nil)
            return;
        
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [foodDicList count]; i++)
        {
            NSDictionary *dic = [foodDicList objectAtIndex:i];
            
            Food *item = [Food new];
            
            item.foodId = [[dic objectForKey:PARAM_KEY_FOOD_ID] intValue];
            item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
            item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
            item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
            item.startDate = [dic objectForKey:PARAM_KEY_START_DATE];
            item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
            
            for (int a = 0; a < [appDelegate.fullFoodList count]; a++)
            {
                Food *food = [appDelegate.fullFoodList objectAtIndex:a];
                if(item.foodId == food.foodId)
                {
                    item.name = food.name;
                    break;
                }
            }
            
            [self.usedFoodList addObject:item];
        }
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [defaults integerForKey:PARAM_KEY_USERID];
    
    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnSaveClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if([tableView isEqual:mTableView])
        return 80.f;
    else
        return 40.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:mTableView])
    {
        if(!usedFoodList)
            return 0;
        else
            return [usedFoodList count];
    }
    else
    {
        if(autoCompleteList)
            return [autoCompleteList count];
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:mTableView])
    {
        FoodTableViewCell *cell = (FoodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FoodTableViewCell"];
        
        if(!cell)
        {
            NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"FoodTableViewCell" owner:self options:nil];
            for(id currentObject in topObjects)
            {
                if([currentObject isKindOfClass:[FoodTableViewCell class]])
                {
                    cell = (FoodTableViewCell *)currentObject;
                    break;
                }
            }
        }
        
        Food *food = [self.usedFoodList objectAtIndex:indexPath.row];
        if(food)
        {
            cell.food = food;
            cell.delegate = self;
            
            [cell initCell];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = nil;
        static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        }
        
        Food *food = [autoCompleteList objectAtIndex:indexPath.row];
        cell.textLabel.text = food.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:mAutoCompleteTableView])
    {
        Food *food = [autoCompleteList objectAtIndex:indexPath.row];
        
        for (int i = 0; i < [usedFoodList count]; i++)
        {
            Food *item = [usedFoodList objectAtIndex:i];
            if(food.foodId == item.foodId)
            {
                NSIndexPath * tmpPath = [NSIndexPath indexPathForRow:i inSection:0];
                [mTableView scrollToRowAtIndexPath:tmpPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                
                [searchBar resignFirstResponder];
                searchBar.text = @"";
                mAutoCompleteTableView.hidden = YES;
                [mTableView reloadData];
                
                return;
            }
        }
        
        [self.usedFoodList addObject:food];
        [searchBar resignFirstResponder];
        searchBar.text = @"";
        mAutoCompleteTableView.hidden = YES;
        
        [mTableView reloadData];
        
        NSIndexPath * tmpPath = [NSIndexPath indexPathForRow:[usedFoodList count] - 1 inSection:0];
        [mTableView scrollToRowAtIndexPath:tmpPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark
#pragma mark - UISearchBar Delegate Function
- (void) searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    if(searchText.length == 0)
    {
        mAutoCompleteTableView.hidden = YES;
        return;
    }
    
    mAutoCompleteTableView.hidden = NO;
    
    [self searchAutocompleteEntriesWithSubstring:searchText];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autoCompleteList removeAllObjects];
    
    for (Food *food in fullFoodList) {
        NSRange range = [[food.name uppercaseString] rangeOfString:[substring uppercaseString]];
        if(range.location != NSNotFound)
            [autoCompleteList addObject:food];
    }
    
    [mAutoCompleteTableView reloadData];
}

- (void) searchBarCancelButtonClicked:(UISearchBar*)_searchBar
{
    mAutoCompleteTableView.hidden = YES;
    _searchBar.text = @"";
    [searchBar resignFirstResponder];
}

#pragma mark
#pragma mark FoodOperationDelegate Function
-(void)foodStart:(Food *)food
{
    if(!food)
        return;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, START_FOOD_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        food.startDate = [Utils getStringFromNSDate:[NSDate date]];
        food.stopDate = nil;
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [defaults integerForKey:PARAM_KEY_USERID];
    
    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_START_DATE];
    [request addPostValue:[NSNumber numberWithInt:food.foodId] forKey:PARAM_KEY_FOOD_ID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

-(void)foodStop:(Food *)food
{
    if(!food)
        return;
    
    if(!food)
        return;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, STOP_FOOD_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        food.stopDate = [Utils getStringFromNSDate:[NSDate date]];
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];

    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_STOP_DATE];
    [request addPostValue:[NSNumber numberWithInt:food.usedId] forKey:PARAM_KEY_ID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

@end
