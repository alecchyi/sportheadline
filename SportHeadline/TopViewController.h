//
//  TopViewController.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "MessageDownloader.h"
#import "MHLazyTableImages.h"
#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface TopViewController : UITableViewController<MHLazyTableImagesDelegate>{
    MHLazyTableImages* lazyImages;
    MBProgressHUD *activity;
    int page;
    BOOL isMore;
}

@end
