//
//  DetailViewController.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController<MBProgressHUDDelegate>{
    IBOutlet UIWebView *webView;
    MBProgressHUD *hud;
}

@property (nonatomic,retain) NSString *messageUrl;

@end
