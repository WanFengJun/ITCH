//
//  LineChartView.m
//  FluffyITCH
//
//  Created by Mimi on 7/7/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView()
{
    CALayer *linesLayer;
    
    
    UIView *popView;
    UILabel *disLabel;
}

@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize hDesc,vDesc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        hInterval = 10;
        vInterval = 30;
        
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        [self.layer addSublayer:linesLayer];
    }
    return self;
}

#define ZeroPoint CGPointMake(30,460)

- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor colorWithRed:153.f/255.f green:174.f/255.f blue:180.f/255.f alpha:1.f];
    
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Paint background lines------------------
    CGColorRef backColorRef = [UIColor clearColor].CGColor;
    CGFloat backLineWidth = 2.f;
    CGFloat backMiterLimit = 0.f;
    
    CGContextSetLineWidth(context, backLineWidth);//Main line width
    CGContextSetMiterLimit(context, backMiterLimit);//Projection angle
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, backColorRef);//Set the double lines
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    

    
//    int x = 320 ;
//    int y = 460 ;
    int x = 270 ;
    int y = 210 ;
    
    for (int i=0; i<vDesc.count; i++) {
        
        CGPoint bPoint = CGPointMake(30, y);
        CGPoint ePoint = CGPointMake(x, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setCenter:CGPointMake(bPoint.x-15, bPoint.y-30)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:color];
        [label setText:[vDesc objectAtIndex:i]];
        
        UIFont *font = label.font;
        [label setFont:[font fontWithSize:12.f]];
        
        [self addSubview:label];
        
        CGContextMoveToPoint(context, bPoint.x, bPoint.y-30);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y-30);
        
        y -= vInterval;
        
    }
    
    for (int i=0; i<array.count-1; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*vInterval+30, 180, 40, 30)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:color];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 1.0f;
        [label setText:[hDesc objectAtIndex:i]];
        
        [self addSubview:label];
    }
    
    
//    //Stippled lines------------------
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 5.0f;
    
    CGContextSetLineWidth(context, pointLineWidth);//main line width
    CGContextSetMiterLimit(context, pointMiterLimit);//projection angle
    
    
//    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, pointColorRef);//projection angle
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:153.f/255.f green:174.f/255.f blue:180.f/255.f alpha:1.f].CGColor);

	//Draw
	CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
	int i = 1;
//	CGContextMoveToPoint(context, p1.x+30, 430-p1.y);

    //
    CGPoint p2 = [[array objectAtIndex:1] CGPointValue];
    CGContextMoveToPoint(context, p2.x, 170 - p2.y);
    //
    
	for (; i<[array count]; i++)
	{
		p1 = [[array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x, 170-p1.y*vInterval/20);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        
        //Add a touch point
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [bt setBackgroundColor:[UIColor redColor]];
        
        [bt setFrame:CGRectMake(0, 0, 10, 10)];
        
        [bt setCenter:goPoint];
        
        [bt addTarget:self 
               action:@selector(btAction:) 
     forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bt];
	}
	CGContextStrokePath(context);
    
}

- (void)btAction:(id)sender{
//    [disLabel setText:@"100"];
//    
//    UIButton *bt = (UIButton*)sender;
//    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
//    [popView setAlpha:1.0f];
}

@end
