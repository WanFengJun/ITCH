//
//  FleasViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/5/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "FleasViewController.h"
#import "FleaTableViewCell.h"
#import "Flea.h"
#import "ITCHAppDelegate.h"
#import "JSON.h"
#import "Utils.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "Dog.h"

@interface FleasViewController ()

@end

@implementation FleasViewController

@synthesize mTableView;
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
    
    [self initFleasList];
    
    [self getFleaCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - Init Fleas List
- (void)initFleasList
{
    fleasList = [NSMutableArray new];
    
    Flea *item = [Flea new];
    item.fleaId = 1;
    item.fleaDesc = @"None observed";
    [fleasList addObject:item];
    
    item = [Flea new];
    item.fleaId = 2;
    item.fleaDesc = @"Flea \"dust\"";
    [fleasList addObject:item];
    
    item = [Flea new];
    item.fleaId = 3;
    item.fleaDesc = @"1-2 fleas";
    [fleasList addObject:item];
    
    item = [Flea new];
    item.fleaId = 4;
    item.fleaDesc = @"3 of more fleas";
    [fleasList addObject:item];
}

- (void)getFleaCount
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, GET_FLEA_URL];
    
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
        
        int count = [[jsonValues objectForKey:PARAM_KEY_DATA] intValue];
        if(count < 0)
        {
            for (int i = 0; i < [fleasList count]; i++)
            {
                Flea *flea = [fleasList objectAtIndex:i];
                flea.isSelected = NO;
            }
        }
        else
        {
            Flea *flea = [fleasList objectAtIndex:count];
            flea.isSelected = YES;
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
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_DATE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnSaveClicked:(id)sender
{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SET_FLEA_URL];
    
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [request setFailedBlock:^{
        [ITCHAppDelegate hideWaitView];
        
        NSError *error = [request error];
        NSLog(@"%@", error.description);
        
        [Utils showAlertMessage:@"Connect failed."];
    }];
    
//    dogId, userId, date, count_value, date
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int userId = [defaults integerForKey:PARAM_KEY_USERID];
    
    [request addPostValue:[NSNumber numberWithInt:userId] forKey:PARAM_KEY_USERID];
    [request addPostValue:[NSNumber numberWithInt:dog.dogId] forKey:PARAM_KEY_DOG_ID];
    [request addPostValue:[Utils getStringFromNSDate:[NSDate date]] forKey:PARAM_KEY_DATE];
    [request addPostValue:[NSNumber numberWithInt:selectedIdx] forKey:PARAM_KEY_COUNT_VALUE];
    
    [request startAsynchronous];
    
    [ITCHAppDelegate showWaitView:@"Loading..."];
}

- (IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fleasList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FleaTableViewCell *cell = (FleaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FleaTableViewCell"];
    
    if(!cell)
    {
        NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"FleaTableViewCell" owner:self options:nil];
        for(id currentObject in topObjects)
        {
            if([currentObject isKindOfClass:[FleaTableViewCell class]])
            {
                cell = (FleaTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    Flea *flea = [fleasList objectAtIndex:indexPath.row];
    
    cell.lblName.text = flea.fleaDesc;
    if(flea.isSelected)
        [cell.imgCheck setImage:[UIImage imageNamed:@"check.png"]];
    else
        [cell.imgCheck setImage:[UIImage imageNamed:@"uncheck.png"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < [fleasList count]; i++)
    {
        Flea *flea = [fleasList objectAtIndex:i];
        if(flea.isSelected)
        {
            flea.isSelected = !flea.isSelected;
            break;
        }
    }
    
    Flea *flea = [fleasList objectAtIndex:indexPath.row];
    flea.isSelected = !flea.isSelected;
    selectedIdx = indexPath.row;
    
    [mTableView reloadData];
}

@end
