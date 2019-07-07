//
//  ComposeViewController.m
//  twitter
//
//  Created by atalwar98 on 7/3/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composedTweet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *constructTweet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closingTweet;
@property (weak, nonatomic) IBOutlet UILabel *charDiff;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composedTweet.delegate = self;
}

- (IBAction)closeTweet:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composedTweet.text stringByReplacingCharactersInRange:range withString:text];
    // TODO: Update Character Count Label
    int diff = characterLimit - newText.length;
    self.charDiff.text = [NSString stringWithFormat:@"You have %i characters remaining.", diff];
    // The new text should be allowed? True/False
    return newText.length < characterLimit;
}

- (IBAction)newTweet:(UIBarButtonItem *)sender {
    [[APIManager shared] postStatusWithText:self.composedTweet.text completion:^(Tweet *tweet, NSError *error) {
        if (error){
            NSLog(@"Error with POST Request %@", error.localizedDescription);
        } else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
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
