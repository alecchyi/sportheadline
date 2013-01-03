//
//  MessageDownloader.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "MessageDownloader.h"

@implementation MessageDownloader

@synthesize messageData,connection;

- (void)sendRequest:(NSString*)urlString limit:(int)limit
{
    messageData =[[NSMutableData alloc] initWithData:nil];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *post = nil;
    post = [[NSString alloc] initWithFormat:@"offset=%d&limit=%d&%@",offset,limit,kAPIKey];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    NSLog(@"-----%@",post);
    [post release];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection != nil) {
        //创建成功
    }else {
        //创建失败
    }
    
    [request release];
    
}

- (void)startDownload:(NSString *)info withType:(NSString *)type page:(int)page{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@", kHost,info];
    messageType = type;
    offset = page * kLimit;
    [self sendRequest:str limit:kLimit];
    [str release];
}

- (void)connection:(NSURLConnection *)connection1 didFailWithError:(NSError *)error{
    messageData = nil;
    connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (data) {
        [messageData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection1{
    if (messageData) {
        NSString *results = [[NSString alloc]
                             initWithBytes:[messageData bytes]
                             length:[messageData length]
                             encoding:NSUTF8StringEncoding];
        NSDictionary *result = [results JSONValue];
        NSMutableArray *messages = [result objectForKey:@"headlines"];
        NSMutableArray *msgs = nil;
        if (offset == 0) {
            msgs = [NSMutableArray array];
        }else{
            msgs = [[DataService sharedService].messages objectForKey:[NSString stringWithFormat:@"%@_messages",messageType]];
            if ([msgs count]>0) {
                [msgs removeLastObject];
            }else{
                msgs = [NSMutableArray array];
            }
        }
        for (NSDictionary *msg in messages) {
            Message *message = [[Message alloc] init];
            message.title = [msg objectForKey:@"headline"];
            message.description = [msg objectForKey:@"description"];
            NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
            [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate* inputDate = [inputFormatter dateFromString:[msg objectForKey:@"published"]];
            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [outputFormatter setLocale:[NSLocale currentLocale]];
            [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *str = [outputFormatter stringFromDate:inputDate];
            message.date = str;
            message.messageUrl = [[[msg objectForKey:@"links"] objectForKey:@"mobile"] objectForKey:@"href"];
            NSMutableArray *images = [msg objectForKey:@"images"];
            if (images && images.count >0) {
                message.imgUrl = [[images objectAtIndex:0] objectForKey:@"url"];
            }else{
                message.imgUrl = @"0";
            }
            [msgs addObject:message];
            [message release];
        }
        Message *mm = [[Message alloc] init];
        mm.title = @"##--";
        mm.imgUrl = @"0";
        [msgs addObject:mm];
        [mm release];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [[DataService sharedService].messages setObject:[result objectForKey:@"resultsCount"] forKey:[NSString stringWithFormat:@"%@_resultsCount",messageType]];
        [[DataService sharedService].messages setObject:[result objectForKey:@"resultsLimit"] forKey:@"resultsLimit"];
        [[DataService sharedService].messages setObject:[result objectForKey:@"resultsOffset"] forKey:@"resultsOffset"];
        [[DataService sharedService].messages setObject:msgs forKey:[NSString stringWithFormat:@"%@_messages",messageType]];

        NSLog(@"%d----%@-----%@---%@",offset,[result objectForKey:[NSString stringWithFormat:@"%@_resultsCount",messageType]],[result objectForKey:@"resultsLimit"],[DataService sharedService].messages);
        [dic release];
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@Message",messageType] object:nil];
        messageData=nil;
        connection = nil;
        [results release];
    }
}

- (void)dealloc{
    [messageData release];
    [connection release];
    [super dealloc];
}

@end
