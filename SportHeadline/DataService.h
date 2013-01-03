//
//  DataService.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject{
    NSMutableDictionary *messages;
    NSString *urlKey;
}
@property (nonatomic,retain) NSMutableDictionary *messages;

+ (DataService *)sharedService;

@end
