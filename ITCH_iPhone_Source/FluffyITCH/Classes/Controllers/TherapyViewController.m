//
//  TherapyViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "TherapyViewController.h"
#import "ITCHAppDelegate.h"
#import "TherapyDetailViewController.h"
#import "TherapyTableViewCell.h"
#import "Dog.h"
#import "Therapy.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "Utils.h"
#import "ASIFormDataRequest.h"
#import "MedFrequency.h"
#import "MedAmount.h"

@interface TherapyViewController ()

@end

@implementation TherapyViewController

@synthesize mTableView, mAutoCompleteTableView, searchBar, lblDogName;
@synthesize dog, usedTherapyList, fullTherapyList;

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
    if(!appDelegate.fullTherapyList)
    {
        // Load full therapy list from web server.
//        appDelegate.fullTherapyList = [self loadFullTherapyList];
    }
    else
        fullTherapyList = appDelegate.fullTherapyList;
    
    [self loadUsedTherapyList];
    
    autoCompleteList = [NSMutableArray new];
    
    lblDogName.text = [NSString stringWithFormat:@"%@\' RECENT THERAPYS", dog.name];
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
#pragma mark - Load Therapy List From Web Server

- (NSMutableArray *)loadFullTherapyList
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_MEDICATION_LIST_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
        
        NSArray *medDicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(medDicList == nil)
            return;
        
        self.fullTherapyList = [NSMutableArray new];
        
        for (int i = 0; i < [medDicList count]; i++)
        {
            NSDictionary *medDic = [medDicList objectAtIndex:i];

            int medId = [[medDic objectForKey:PARAM_KEY_MEDID] intValue];
            NSString *medName = [medDic objectForKey:PARAM_KEY_MED_NAME];
            NSString *medUnit = [medDic objectForKey:PARAM_KEY_MED_UNIT];
            int cycleType = [[medDic objectForKey:PARAM_KEY_MED_CYCLE_TYPE] intValue];
            int cycleValue = [[medDic objectForKey:PARAM_KEY_MED_CYCLE_VALUE] intValue];
            int isOn = [[medDic objectForKey:PARAM_KEY_IS_ON] intValue];
            
            Therapy *item = [Therapy new];
            
            item.therapyId = medId;
            item.name = medName;
            item.unit = medUnit;
            item.cycleType = cycleType;
            item.cycle = cycleValue;
            item.isOn = isOn == 1 ? YES : NO;
            
            [self.fullTherapyList addObject:item];
        }
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
    
    return nil;
}

/** Get used therapy list from web server with user_id, dog_id */
- (void)loadUsedTherapyList
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_USED_MED_LIST_URL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    
    [request setCompletionBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSString *responseString = [request responseString];
        NSDictionary *jsonValues = [responseString JSONValue];
        
        int success = [[jsonValues objectForKey:PARAM_KEY_SUCCESS] integerValue];
        NSString *message = [jsonValues objectForKey:PARAM_KEY_MESSAGE];
        NSArray *medDicList = [jsonValues objectForKey:PARAM_KEY_DATA];
        if(medDicList == nil)
            return;
        
        if(success == 0)
        {
            [Utils showAlertMessage:message];
            return;
        }
        
        self.usedTherapyList = [NSMutableArray new];
        
        ITCHAppDelegate *appDelegate = (ITCHAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [medDicList count]; i++)
        {
            NSDictionary *dic = [medDicList objectAtIndex:i];
            
            Therapy *item = [Therapy new];
            
            item.therapyId = [[dic objectForKey:PARAM_KEY_MEDID] intValue];
            item.userId = [[dic objectForKey:PARAM_KEY_USERID] intValue];
            item.dogId = [[dic objectForKey:PARAM_KEY_DOG_ID] intValue];
            item.checkCount = [[dic objectForKey:PARAM_KEY_CHECK_COUNT] intValue];
            item.checkIndex = [[dic objectForKey:PARAM_KEY_CHECK_INDEX] intValue];
            item.frequencyId = [[dic objectForKey:PARAM_KEY_FREQUENCY_ID] intValue];
            item.amountId = [[dic objectForKey:PARAM_KEY_UNIT_ID] intValue];
            item.isOn = [[dic objectForKey:PARAM_KEY_IS_ON] boolValue];
            item.startedDate = [dic objectForKey:PARAM_KEY_START_DATE];
            item.stopDate = [dic objectForKey:PARAM_KEY_STOP_DATE];
            item.usedId = [[dic objectForKey:PARAM_KEY_ID] intValue];
            
            if([item.stopDate isKindOfClass:[NSNull class]])
                item.stopDate = nil;
            else if([item.stopDate isEqualToString:@"0000-00-00 00:00:00"])
                item.stopDate = nil;
            
            for (int a = 0; a < [appDelegate.fullTherapyList count]; a++)
            {
                Therapy *therapy = [appDelegate.fullTherapyList objectAtIndex:a];
                if(therapy.therapyId == item.therapyId)
                {
                    item.name = therapy.name;
                    break;
                }
            }
            
            for (int ci = 0; ci < [appDelegate.medFrequencyList count]; ci++)
            {
                MedFrequency *freq = [appDelegate.medFrequencyList objectAtIndex:ci];
                if(freq.frequencyId == item.frequencyId)
                {
                    item.frequency = freq;
                    break;
                }
            }
            
            for (int ai = 0; ai < [appDelegate.medAmountList count]; ai++)
            {
                MedAmount *amount = [appDelegate.medAmountList objectAtIndex:ai];
                if(amount.amountId == item.amountId)
                {
                    item.amount = amount;
                    item.unit = amount.name;
                    break;
                }
            }
            
            if(item.frequencyId == 1 || item.frequencyId == 2 || item.frequencyId == 3)
            {
                item.cycle = [item.frequency.name intValue];
                item.cycleType = CYCLE_TYPE_HOUR;
            }
            else if(item.frequencyId == 4)
            {
                item.cycleType = CYCLE_TYPE_DAY;
                item.cycle = 1;
            }
            else
            {
                item.cycle = [item.frequency.name intValue];
                item.cycleType = CYCLE_TYPE_DAY;
            }
            
            [self.usedTherapyList addObject:item];
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
        if(!usedTherapyList)
            return 0;
        else
            return [usedTherapyList count];
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
        TherapyTableViewCell *cell = (TherapyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TherapyTableViewCell"];
        
        if(!cell)
        {
            NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"TherapyTableViewCell" owner:self options:nil];
            for(id currentObject in topObjects)
            {
                if([currentObject isKindOfClass:[TherapyTableViewCell class]])
                {
                    cell = (TherapyTableViewCell *)currentObject;
                    break;
                }
            }
        }
        
        Therapy *therapy = [self.usedTherapyList objectAtIndex:indexPath.row];
        if(therapy)
        {
            cell.therapy = therapy;
            [cell initCell];
            cell.delegate = self;
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
        
        Therapy *therapy = [autoCompleteList objectAtIndex:indexPath.row];
        cell.textLabel.text = therapy.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:mTableView])
    {
        Therapy *therapy = [self.usedTherapyList objectAtIndex:indexPath.row];
        
        TherapyDetailViewController *vc = [[TherapyDetailViewController alloc] initWithNibName:@"TherapyDetailViewController" bundle:nil];
        vc.therapy = therapy;
        vc.dog = dog;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        Therapy *therapy = [autoCompleteList objectAtIndex:indexPath.row];
        
        for (int i = 0; i < [usedTherapyList count]; i++)
        {
            Therapy *item = [usedTherapyList objectAtIndex:i];
            if(therapy.therapyId == item.therapyId)
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
        
        [self.usedTherapyList addObject:therapy];
        [searchBar resignFirstResponder];
        searchBar.text = @"";
        mAutoCompleteTableView.hidden = YES;
        [mTableView reloadData];
        
        NSIndexPath * tmpPath = [NSIndexPath indexPathForRow:[usedTherapyList count] - 1 inSection:0];
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
    
    for (Therapy *therapy in fullTherapyList) {
        NSRange range = [[therapy.name uppercaseString] rangeOfString:[substring uppercaseString]];
        if(range.location != NSNotFound)
           [autoCompleteList addObject:therapy];
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
#pragma mark MedTickCheckDelegate
-(void)tickCheck:(Therapy *)therapy
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, USED_MED_CHECK_URL];
    
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
        
        therapy.checkIndex++;
        
        [mTableView reloadData];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
    [request addPostValue:[NSNumber numberWithInt:therapy.usedId] forKey:PARAM_KEY_ID];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

@end
