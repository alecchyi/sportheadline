//
//  Message.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *imgUrl;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *messageUrl;
@property (nonatomic,retain) NSData *imageData;

@end
