//
//  MessageCell.m
//  SportHeadline
//
//  Created by Ruby on 12-12-22.
//  Copyright (c) 2012年 sport. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize lblDate,lblDescription,lblTitle,headImage;

- (void)initView:(BOOL)hasImg{
    CGRect imgFrame = CGRectZero;
    CGRect titleFrame = CGRectMake(90, 5, 220, 20);
    CGRect descripFrame = CGRectMake(90, 42, 220, 42);
    imgFrame = CGRectMake(3, 3, 80, 80);
    self.headImage = [[[UIImageView alloc] initWithFrame:imgFrame] autorelease];
    [self addSubview:headImage];
    self.lblTitle = [[[UILabel alloc] initWithFrame:titleFrame] autorelease];
    [self addSubview:lblTitle];
    self.lblDate = [[[UILabel alloc] initWithFrame:CGRectMake(90, 25, 220, 20)] autorelease];
    lblDate.font = [UIFont systemFontOfSize:13.0f];
    lblDate.textAlignment = NSTextAlignmentRight;
    [self addSubview:lblDate];
    self.lblDescription = [[[UILabel alloc] initWithFrame:descripFrame] autorelease];
    lblDescription.font = [UIFont systemFontOfSize:14.0f];
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblDescription.numberOfLines = 3;
    [self addSubview:lblDescription];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasImage:(BOOL)hasImg
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, kRowHeight);
        [self initView:hasImg];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc{
    [super dealloc];
}
@end
