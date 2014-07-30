//
//  ChangeDogViewController.m
//  FluffyITCH
//
//  Created by Mimi on 7/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "ChangeDogViewController.h"
#import "DogTableViewCell.h"
#import "Dog.h"
#import "Constants.h"
#import "AddDogViewController.h"
#import "ITCHAppDelegate.h"

@interface ChangeDogViewController ()

@end

@implementation ChangeDogViewController

@synthesize mTableView;
@synthesize dogList;
@synthesize from;

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
    self.dogList = appDelegate.dogList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UIButton Click Handler
- (IBAction)btnCloseClicked:(id)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:selectedDog forKey:@"dog_data"];
    
    if(from == FROM_RECORD_VIEW)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_DOG object:nil userInfo:dic];
    else if(from == FROM_HISTORY_VIEW)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HISTORY_CHANGE_DOG object:nil userInfo:dic];
    else if(from == FROM_REPORT_VIEW)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPORT_CHAGE_DOG object:nil userInfo:dic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddClicked:(id)sender
{
    AddDogViewController *vc = [[AddDogViewController alloc] initWithNibName:@"AddDogViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.dogList)
        return 0;
    else
        return [self.dogList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DogTableViewCell *cell = (DogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DogTableViewCell"];
    
    if(!cell)
    {
        NSArray * topObjects = [[NSBundle mainBundle] loadNibNamed:@"DogTableViewCell" owner:self options:nil];
        for(id currentObject in topObjects)
        {
            if([currentObject isKindOfClass:[DogTableViewCell class]])
            {
                cell = (DogTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    Dog *dog = [self.dogList objectAtIndex:indexPath.row];
    if(dog)
    {
        cell.lblName.text = dog.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedDog = [dogList objectAtIndex:indexPath.row];
}

@end
