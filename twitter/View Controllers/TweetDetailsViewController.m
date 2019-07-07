//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by atalwar98 on 7/6/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *tweetDetailsAuthor;
@property (weak, nonatomic) IBOutlet UILabel *tweetDetailsScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDetailsBody;
@property (weak, nonatomic) IBOutlet UILabel *tweetDetailsDate;
@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetDetailsBody.text = self.prevTweet.text;
    self.tweetDetailsDate.text = self.prevTweet.createdAtString;
    self.tweetDetailsAuthor.text = self.prevTweet.user.name;
    self.tweetDetailsScreenName.text = self.prevTweet.user.screenName;
    NSString *pictureURL = self.prevTweet.user.profileUrl;
    NSURL *url = [NSURL URLWithString:pictureURL];
    [self.tweetDetailsView setImageWithURL:url];
    if(self.prevTweet.favorited){
        [self.tweetDetailsFav setSelected:YES];
    }
    if(self.prevTweet.retweeted){
        [self.tweetDetailsRetweet setSelected:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
