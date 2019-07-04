//
//  TweetCell.h
//  twitter
//
//  Created by atalwar98 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetAuthor;
@property (weak, nonatomic) IBOutlet UILabel *tweetBody;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *favCount;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
- (IBAction)didTapFavorite:(UIButton *)sender;
@property(strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
