//
//  MessageDownloader.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageDownloader : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData *messageData;
    NSURLConnection *connection;
    NSString *messageType;
    int offset;
}

@property (nonatomic,retain) NSMutableData *messageData;
@property (nonatomic,retain) NSURLConnection *connection;

- (void)startDownload:(NSString *)info withType:(NSString *)type page:(int)page;

@end
