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

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetView;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //step 3 - view controller becomes datasource and delegate
    self.tweetView.dataSource = self;
    self.tweetView.delegate = self;
    self.tweetView.rowHeight = 300;
    
    //initializing pull to refresh control feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
     [self.tweetView insertSubview:refreshControl atIndex:0];
    
    [self fetchTweets];
    
}

- (void) fetchTweets {
    // Get timeline
    //first time shared is called you are instantiating an APIManager instance:
    //step 4 - make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //step 6 - view controller stores data passed into completion handler
            self.tweets = [NSArray arrayWithArray:tweets];
            NSLog(@"set tweets successfully");
            for (Tweet *tweetObj in tweets) {
                NSString *text = tweetObj.text;
                NSLog(@"%@", text);
            }
            //table view asks its datasource for numbersOfRows and cellForRowAt
            //step 7 - reload table view
            //also step 8 because reload fxn calls numberOfRows and cellForRowAt
            [self.tweetView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    /*
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil
        delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
           // ... Use the new data to update the data source
            //Do I need to handle "data" here?
            [self fetchTweets];
            
           // Reload the tableView now that there is new data
           [self.tweetView reloadData];
                                                
           // Tell the refreshControl to stop spinning
           [refreshControl endRefreshing];
        }];
    
    [task resume];
     */
    [self fetchTweets];
    [refreshControl endRefreshing];
}

-(void)loadMoreData{
    
    // ... Create the NSURLRequest (myRequest) ...
    // Create NSURL and NSURLRequest
    /*
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // Configure session so that completion handler is executed on main UI thread
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
        if (requestError != nil) {
            
        }
        else
        {
            // Update flag
            self.isMoreDataLoading = false;
            
            // ... Use the new data to update the data source ...
            [self fetchTweets];
            
            // Reload the tableView now that there is new data
            [self.tweetView reloadData];
        }
    }];
    [task resume];
     */
    self.isMoreDataLoading = false;
    
    // ... Use the new data to update the data source ...
    [self fetchTweets];
    
    // Reload the tableView now that there is new data
    [self.tweetView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tweetView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tweetView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//step 9 - returns number of items returned from API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}
//step 10 - returns an instance of the custom cell with that reuse identifier
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
