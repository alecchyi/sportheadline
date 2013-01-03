//
//  MessageCell.h
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell{
    UILabel *lblTitle;
    UILabel *lblDescription;
    UILabel *lblDate;
    UIImageView *headImage;
}

@property (nonatomic,retain) UIImageView *headImage;
@property (nonatomic,retain) UILabel *lblDescription;

@property (nonatomic,retain) UILabel *lblTitle;
@property (nonatomic,retain) UILabel *lblDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasImage:(BOOL)hasImg;

@end
