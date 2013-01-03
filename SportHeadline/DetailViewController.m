//
//  DetailViewController.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize messageUrl;

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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.messageUrl]]];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.dimBackground = NO;
    [hud show:YES];
    [self.navigationController.view addSubview:hud];
    [hud hide:YES afterDelay:6];
    [hud release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    hud = nil;
    [hud release];
    [webView stopLoading];
}

@end
