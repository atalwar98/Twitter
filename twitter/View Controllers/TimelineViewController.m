//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "User.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tweetView;

@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetView.dataSource = self;
    self.tweetView.delegate = self;
    self.tweetView.rowHeight = 300;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = [NSArray arrayWithArray:tweets];
            NSLog(@"set tweets successfully");
            for (Tweet *tweetObj in tweets) {
                NSString *text = tweetObj.text;
                NSLog(@"%@", text);
            }
            [self.tweetView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"inside cellforRow");
    TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *post = self.tweets[indexPath.row];
    User *user = post.user;
    tweetCell.tweetAuthor.text = user.name;
    
    tweetCell.tweetBody.text = post.text;
    tweetCell.tweetScreenName.text = user.screenName;
    tweetCell.tweetDate.text = post.createdAtString;
    NSString* retweetToString = [NSString stringWithFormat:@"%i", post.retweetCount];
    tweetCell.retweetCount.text = retweetToString;
    NSString* favToString = [NSString stringWithFormat:@"%i", post.favoriteCount];
    tweetCell.favCount.text = favToString;
    //NSLog(@"tweet's body %@", post.text);
    NSString *profileUrl = user.profileUrl;
    //NSLog(@"tweet's image url %@", profileUrl);
    NSURL *url = [NSURL URLWithString:profileUrl];
    
     
    [tweetCell.tweetImage setImageWithURL:url];
    
    return tweetCell;
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
