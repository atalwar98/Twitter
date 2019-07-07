//
//  TweetCell.m
//  twitter
//
//  Created by atalwar98 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(UIButton *)sender {
    NSLog(@"Is tweet favorited? %d", self.tweet.favorited);
    if(self.tweet.favorited){
        self.tweet.favoriteCount = self.tweet.favoriteCount - 1;
        self.tweet.favorited = NO;
        [self refreshData];
        [self.favButton setSelected:NO];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.favoriteCount = self.tweet.favoriteCount + 1;
        self.tweet.favorited = YES;
        [self refreshData];
        [self.favButton setSelected:YES];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(UIButton *)sender {
    if(self.tweet.retweeted){
        self.tweet.retweetCount = self.tweet.retweetCount - 1;
        self.tweet.retweeted = NO;
        [self refreshData];
        [self.retweetButton setSelected:NO];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.retweetCount = self.tweet.retweetCount + 1;
        self.tweet.retweeted = YES;
        [self refreshData];
        [self.retweetButton setSelected:YES];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void) refreshData{
    NSString *fav = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.favCount.text = fav;
    NSString *retweeted = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.retweetedCount.text = retweeted;
}

@end
