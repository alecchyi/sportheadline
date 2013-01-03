//
//  Constant.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#define kHost @"http://api.espn.com/v1"

//For top headlines: http://api.espn.com/v1/sports/news/headlines/top?offset=0&limit=10&apikey=ng4sxswp8h2c2fup6fbys3dq
//For all headlines: http://api.espn.com/v1/sports/news/headlines?offset=0&limit=10&apikey=ng4sxswp8h2c2fup6fbys3dq
//For NBA: http://api.espn.com/v1/sports/basketball/nba/news/headlines?offset=0&limit=10&apikey=ng4sxswp8h2c2fup6fbys3dq
//For Football: http://api.espn.com/v1/fantasy/football/news/headlines?offset=0&limit=10&apikey=ng4sxswp8h2c2fup6fbys3dq

#define kTop @"/sports/news/headlines/top"
#define kAll @"/sports/news/headlines"
#define kNBA @"/sports/basketball/nba/news/headlines"
#define kFootball @"/fantasy/football/news/headlines"
#define kAPIKey @"apikey=ng4sxswp8h2c2fup6fbys3dq"
#define kLimit 10
#define kAppIconHeight    80
#define kRowHeight 90
#define kToastBottomOffset 50
#define kToastDuration 3

#define kTopMsg @"top_messages"
#define kAllMsg @"all_messages"
#define kNBAMsg @"nba_messages"
#define kFootMsg @"foot_messages"

#define kTopCount @"top_resultsCount"
#define kAllCount @"all_resultsCount"
#define kNBACount @"nba_resultsCount"
#define kFootCount @"foot_resultsCount"