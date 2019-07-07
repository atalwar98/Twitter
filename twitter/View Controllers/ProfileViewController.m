//
//  ProfileViewController.m
//  twitter
//
//  Created by atalwar98 on 7/6/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonalTweetCell.h"
#import "User.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tweetsAndRetweetsView;
@end

@implementation ProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetsAndRetweetsView.dataSource = self;
    self.tweetsAndRetweetsView.delegate = self;
}
- (IBAction)closeTweetsAndRetweets:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalTweetCell *personalCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalTweetCell"];
    Tweet *post = self.filteredTweets[indexPath.row];
    User *user = post.user;
    personalCell.tweetText.text = post.text;
    personalCell.tweetAuthor.text = user.name;
    personalCell.tweetScreenName.text = user.screenName;
    NSString *profileURL = user.profileUrl;
    NSURL *url = [NSURL URLWithString:profileURL];
    [personalCell.tweetImage setImageWithURL:url];
    if(post.favorited){
        [personalCell.favoriteButton setSelected:YES];
    }
    if(post.retweeted){
        [personalCell.reTweetButton setSelected:YES];
    }
    return personalCell;
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
