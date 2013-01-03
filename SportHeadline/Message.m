//
//  Message.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize title,imgUrl,description,date,messageUrl,imageData;


- (void)dealloc{
    [title release];
    [description release];
    [imgUrl release];
    [date release];
    [messageUrl release];
    [imageData release];
    [super dealloc];
}

@end
