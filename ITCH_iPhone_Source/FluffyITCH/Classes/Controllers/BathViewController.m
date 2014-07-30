//
//  BathViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BathViewController.h"
#import "ITCHAppDelegate.h"
#import "BathingDetailViewController.h"
#import "BathTableViewCell.h"
#import "Bathing.h"
#import "Dog.h"
#import "Constants.h"
#import "Utils.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface BathViewController ()

@end

@implementation BathViewController

@synthesize mTableView, mAutoCompleteTableView, lblDogName, searchBar;
@synthesize dog;

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
    
    ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
    fullBathingList = appDelegate.fullBathingList;
    
    autoCompleteList = [NSMutableArray new];
    
    lblDogName.text = [NSString stringWithFormat:@"%@\' RECENT THERAPYS", dog.name];
    
    [self loadUsedBathingList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [mTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Init Bathing List
- (void)loadUsedBathingList
{
    usedBathingList = [NSMutableArray new];

    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_USED_BATHING_LIST_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        
        NSArray *bathingDicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(bathingDicList == nil)
            return;

        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }

        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [bathingDicList count]; i++)
        {
            NSDictionary *dic = [bathingDicList objectAtIndex:i];
            
            Bathing *item = [Bathing new];
            
            item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
            item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
            item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
            item.bathingId = [[dic objectForKey:PARAM_KEY_BATHING_ID] intValue];
            item.cycle = [[dic objectForKey:PARAM_KEY_CYCLE] intValue];
            item.isOn = [[dic objectForKey:PARAM_KEY_IS_ON] boolValue];
            item.startedDate = [dic objectForKey:PARAM_KEY_START_DATE];
            item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
            
            if([item.stopDate isKindOfClass:[NSNull class]])
                item.stopDate = nil;
            else if([item.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                item.stopDate = nil;
            
            for (int a = 0; a < [appDelegate.fullBathingList count]; a++)
            {
                Bathing *bathing = [appDelegate.fullBathingList objectAtIndex:a];
                if(item.bathingId == bathing.bathingId)
                {
                    item.name = bathing.name;
                    break;
                }
            }
            
            [usedBathingList addObject:item];
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
        if(!usedBathingList)
            return 0;
        else
            return [usedBathingList count];
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
        BathTableViewCell *cell = (BathTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BathTableViewCell"];
        
        if(!cell)
        {
            NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"BathTableViewCell" owner:self options:nil];
            for(id currentObject in topObjects)
            {
                if([currentObject isKindOfClass:[BathTableViewCell class]])
                {
                    cell = (BathTableViewCell *)currentObject;
                    break;
                }
            }
        }
        
        Bathing *item = [usedBathingList objectAtIndex:indexPath.row];
        if(item)
        {
            cell.bathing = item;
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
        
        Bathing *bathing = [autoCompleteList objectAtIndex:indexPath.row];
        cell.textLabel.text = bathing.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:mTableView])
    {
        Bathing *item = [usedBathingList objectAtIndex:indexPath.row];
        BathingDetailViewController *vc = [[BathingDetailViewController alloc] initWithNibName:@"BathingDetailViewController" bundle:nil];
        vc.dog = dog;
        vc.bathing = item;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        Bathing *bathing = [autoCompleteList objectAtIndex:indexPath.row];
        
        for (int i = 0; i < [usedBathingList count]; i++)
        {
            Bathing *item = [usedBathingList objectAtIndex:i];
            if(bathing.bathingId == item.bathingId)
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
        
        [usedBathingList addObject:bathing];
        [searchBar resignFirstResponder];
        searchBar.text = @"";
        mAutoCompleteTableView.hidden = YES;
        [mTableView reloadData];
        
        NSIndexPath * tmpPath = [NSIndexPath indexPathForRow:[usedBathingList count] - 1 inSection:0];
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
    
    for (Bathing *bathing in fullBathingList) {
        NSRange range = [[bathing.name uppercaseString] rangeOfString:[substring uppercaseString]];
        if(range.location != NSNotFound)
            [autoCompleteList addObject:bathing];
    }
    
    [mAutoCompleteTableView reloadData];
}

- (void) searchBarCancelButtonClicked:(UISearchBar*)_searchBar
{
    mAutoCompleteTableView.hidden = YES;
    _searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
