//
//  CustomTabBar.m
//  FluffyITCH
//
//  Created by Mimi on 7/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_record"]];
    [_tabbarView setFrame:CGRectMake(0, 0, _tabbarView.bounds.size.width, TAB_BAR_HEIGHT)];
    [_tabbarView setUserInteractionEnabled:YES];
    
    [self addSubview:_tabbarView];
    
    [self layoutBtn];
}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_1 setFrame:CGRectMake(0, 0, 64, TAB_BAR_HEIGHT)];
    [_button_1 setTag:101];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(65, 0, 64, TAB_BAR_HEIGHT)];
    [_button_2 setTag:102];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(128, 0, 64, TAB_BAR_HEIGHT)];
    [_button_3 setTag:103];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(202, 0, 64, TAB_BAR_HEIGHT)];
    [_button_4 setTag:104];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_5 setFrame:CGRectMake(267, 0, 64, TAB_BAR_HEIGHT)];
    [_button_5 setTag:105];
    [_button_5 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    [_tabbarView addSubview:_button_5];
}

-(void)btn1Click:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 101:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tab_record"]];
            [self.delegate touchBtnAtIndex:0];
            
            break;
        }
        case 102:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tab_calendar"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tab_reprot"]];
            [self.delegate touchBtnAtIndex:2];
            break;
        }
        case 104:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tab_community"]];
            [self.delegate touchBtnAtIndex:3];
            break;
        }
        case 105:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tab_profile"]];
            [self.delegate touchBtnAtIndex:4];
            break;
        }
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
