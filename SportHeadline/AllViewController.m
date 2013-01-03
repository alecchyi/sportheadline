//
//  AllViewController.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "AllViewController.h"

@interface AllViewController ()

@end

@implementation AllViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"All Headlines", @"All Headlines");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        self.tabBarItem.title = @"All";
        lazyImages = [[MHLazyTableImages alloc] init];
        lazyImages.placeholderImage = [UIImage imageNamed:@"placeholder"];
        lazyImages.delegate = self;
    }
    return self;
}

- (void)refreshData{
    [activity hide:YES];
    [activity release];
    [self.tableView reloadData];
    if ([[[DataService sharedService].messages objectForKey:kAllCount] intValue] > [[[DataService sharedService].messages objectForKey:kAllMsg] count] - 1) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[[[DataService sharedService].messages objectForKey:kAllCount] intValue] - [[[DataService sharedService].messages objectForKey:kAllMsg] count] + 1];
    }else{
        self.tabBarItem.badgeValue = nil;
    }
    isMore = YES;
}

- (void)reloadMessage{
    page = 0;
    activity = [[MBProgressHUD alloc] initWithView:self.view];
    activity.center = self.view.center;
    [self.view addSubview:activity];
    [activity show:YES];
    [activity hide:YES afterDelay:5];
    [activity release];
    MessageDownloader *downloader = [[MessageDownloader alloc] init];
    [downloader startDownload:kAll withType:@"all" page:page];
    [downloader release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = kRowHeight;
    page = 0;
    MessageDownloader *downloader = [[MessageDownloader alloc] init];
    [downloader startDownload:kAll withType:@"all" page:page];
    [downloader release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"allMessage" object:nil];
    lazyImages.tableView = self.tableView;
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadMessage)];
    self.navigationItem.rightBarButtonItem = refreshItem;
    [refreshItem release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = [[DataService sharedService].messages objectForKey:kAllMsg];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    Message *message = [[[DataService sharedService].messages objectForKey:kAllMsg] objectAtIndex:indexPath.row];
    BOOL b = NO;
    if (![message.imgUrl isEqualToString:@"0"]) {
        b = YES;
    }
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier hasImage:b] autorelease];
    }
    if (indexPath.row + 1 == [[[DataService sharedService].messages objectForKey:kAllMsg] count]) {
        cell.lblDescription.hidden = YES;
        cell.lblDate.hidden = YES;
        cell.headImage.hidden = YES;
        cell.lblTitle.text = @"More";
    }else{
        cell.lblDate.hidden= NO;
        cell.lblDescription.hidden = NO;
        cell.lblTitle.text = message.title;
        cell.headImage.hidden = NO;
        cell.lblDescription.text = message.description;
        if (b) {
            [lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
        }else{
            cell.headImage.image = [UIImage imageNamed:@"placeholder"];
        }
        
        cell.lblDate.text = message.date;
    }
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	[lazyImages scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	[lazyImages scrollViewDidEndDecelerating:scrollView];
}

#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
	Message* msg = [[[DataService sharedService].messages objectForKey:kAllMsg] objectAtIndex:indexPath.row];
	return [NSURL URLWithString:msg.imgUrl];
}

- (UIImage*)postProcessLazyImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath
{
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    }
    else
    {
        return image;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row + 1 == [[[DataService sharedService].messages objectForKey:kAllMsg] count]){
        return 40;
    }else{
        return kRowHeight;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 == [[[DataService sharedService].messages objectForKey:kAllMsg] count]  && isMore){
        if ([[[DataService sharedService].messages objectForKey:kAllCount] intValue] > [[[DataService sharedService].messages objectForKey:kAllMsg] count] - 1) {
            page++;
            activity = [[MBProgressHUD alloc] initWithView:self.view];
            activity.center = self.view.center;
            [self.view addSubview:activity];
            [activity show:YES];
            [activity hide:YES afterDelay:5];
            [activity release];
            MessageDownloader *downloader = [[MessageDownloader alloc] init];
            [downloader startDownload:kAll withType:@"all" page:page];
            [downloader release];
            isMore = NO;
        }else{
            [OMGToast showWithText:@"At last" bottomOffset:kToastBottomOffset duration:kToastDuration];
        }
        
    }else if(indexPath.row + 1 < [[[DataService sharedService].messages objectForKey:kAllMsg] count]){
        DetailViewController *detailView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        Message *message = [[[DataService sharedService].messages objectForKey:kAllMsg] objectAtIndex:indexPath.row];
        detailView.title = message.title;
        detailView.messageUrl = message.messageUrl;
        [self.navigationController pushViewController:detailView animated:YES];
        [detailView release];
    }
}

@end
