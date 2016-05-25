//
//  ViewController.m
//  mySafariDay2
//
//  Created by Pasha Bahadori on 5/24/16.
//  Copyright © 2016 Pelican Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
- (IBAction)onBackButtonPressed:(UIButton*)sender;
- (IBAction)onForwardButtonPressed:(UIButton *)sender;
- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender;
- (IBAction)onReloadButtonPressed:(UIButton *)sender;
- (IBAction)onPlusButtonPressed:(UIButton *)sender;
@property double lastContentOffset;



@end

@implementation ViewController

- (void)viewDidLoad {
    self.webView.scrollView.delegate = self;
    [super viewDidLoad];
    [self loadFromString:@"http://www.google.com"];
}

-(void)loadFromString:(NSString *)urlString {
    // Step 11: Typing urls without the http://
    if (!([urlString containsString:@"http://"] || [urlString containsString:@"https://"])){
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }
    self.urlTextField.text = urlString;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loadFromString:textField.text];
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.networkActivityIndicator startAnimating];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.urlTextField.text = self.webView.request.URL.relativeString;
    [self.networkActivityIndicator stopAnimating];
}

-(void)onBackButtonPressed:(UIButton *)sender{
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }
    
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    if ([self.webView canGoForward]){
        [self.webView goForward];
    }
}

- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}

- (IBAction)onPlusButtonPressed:(UIButton *)sender {
    
    
    UIAlertController *teaserAlertController = [UIAlertController alertControllerWithTitle:@"Teaser Alert" message:@"Coming soon!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    [teaserAlertController addAction:okButton];
    

    [self presentViewController:teaserAlertController animated:YES completion:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)webView{
    self.lastContentOffset = webView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)webView{
    if (webView.contentOffset.y > self.lastContentOffset){
        
        //TODO: Implement change of top border of web View to follow bottom border of urlTextField
        
        self.lastContentOffset = webView.contentOffset.y;
        if (self.urlTextField.alpha >.1)
            self.urlTextField.alpha -= .1;
        if (self.urlTextField.frame.size.height >=3){
            //NSLog(@"%f",self.webView.frame.size.height);
            self.urlTextField.frame = CGRectMake(self.urlTextField.frame.origin.x, self.urlTextField.frame.origin.y, self.urlTextField.frame.size.width, self.urlTextField.frame.size.height-3 );
            
                [self.webView setFrame: CGRectMake(webView.frame.origin.x, webView.frame.origin.y-3, webView.frame.size.width, webView.frame.size.height)];
        }
    }

    
    else{
        if (self.urlTextField.alpha <=.9)
            self.urlTextField.alpha += .1;
        else if (self.urlTextField.frame.size.height<=27){

           // NSLog(@"Increasing height to %f",self.urlTextField.frame.size.height+3);
            self.urlTextField.frame = CGRectMake(self.urlTextField.frame.origin.x, self.urlTextField.frame.origin.y, self.urlTextField.frame.size.width, self.urlTextField.frame.size.height+3 );
            
            [self.webView setFrame: CGRectMake(webView.frame.origin.x, 0+self.urlTextField.frame.size.height, webView.frame.size.width, webView.frame.size.height)];
        }
    }

    
}
@end
