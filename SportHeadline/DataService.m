//
//  DataService.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "DataService.h"

@implementation DataService

@synthesize messages;

- (id)init {
    if(self = [super init]) {
        self.messages = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [messages release];
    [super dealloc];
}

+ (id)alloc {
    NSAssert(0, @"Use +sharedInstance instead of +alloc.");
    return nil;
}

+ (id)new {
    return [self alloc];
}

- (id)copyWithZone:(NSZone *)zone {
    NSAssert(0, @"Users: attempt to -copy may be a bug(singleton)");
    return self;
}

- (id)mutableCopyWitZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

+ (DataService *)sharedService {
    static dispatch_once_t once;
    static DataService *dataService = nil;
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

@end
