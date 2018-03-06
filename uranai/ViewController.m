//
//  ViewController.m
//  uranai
//
//  Created by shidayamasyuuhei on 2018/02/01.
//  Copyright © 2018年 shidayamasyuuhei. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>


@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property int headerViewPosY;

@property CGPoint scrollBeginingPoint;
@property CGPoint currentPoint;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *fowardBtn;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //wkwebview
    UIScreen *us = [UIScreen mainScreen];
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, us.bounds.size.width, us.bounds.size.height-_bottomView.bounds.size.height)];
    //自分自身にデリゲートを設定する
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    _wkWebView.scrollView.delegate = self;
    //
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    
    
    
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:topurl]]];
    [self.view addSubview:_wkWebView];
    [self.view addSubview:_bottomView];
    
    
    //次のページがない場合は次へのボタンを消す
    if(![_wkWebView canGoForward]){
        _backBtn.hidden = YES;
    }
    
    //前のページがない場合は戻るのボタンを消す
    if(![_wkWebView canGoBack]){
        _fowardBtn.hidden = YES;
    }
    
}

-(void)viewDidLayoutSubviews{
    if([UIScreen mainScreen].bounds.size.height == 812){
        _headerViewPosY = self.view.safeAreaInsets.top;
        _headerView.frame = CGRectMake(_headerView.frame.origin.x, self.view.safeAreaInsets.top, _headerView.frame.size.width, _headerView.frame.size.height);
        [self.view addSubview:_headerView];
    }else
    {
        _headerViewPosY = _headerView.frame.origin.y;
        _headerView.frame = CGRectMake(_headerView.frame.origin.x,_headerView.frame.origin.y, _headerView.frame.size.width, _headerView.frame.size.height);
        [self.view addSubview:_headerView];
    }
    NSLog(@"headerview:%f",_headerView.frame.origin.y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"読み込み開始:%@",navigation);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"読み込み中:%@",navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"読み込み完了:%@",navigation);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([_wkWebView canGoForward]){
        _fowardBtn.hidden = NO;
    }else if(![_wkWebView canGoForward]){
        _fowardBtn.hidden = YES;
    }
    if([_wkWebView canGoBack]){
        _backBtn.hidden = NO;
    }else if(![_wkWebView canGoBack]){
        _backBtn.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"4:%@",navigation);
}


//basic認証かけてるページがあるときはここにidとpassを入力
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeUseCredential;
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"test" password:@"123455" persistence:NSURLCredentialPersistenceForSession];
    completionHandler(disposition, credential);
}

//画面下のボタン系1
- (IBAction)btn1:(id)sender {
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:topurl]]];
}

//画面下のボタン系2
- (IBAction)btn2:(id)sender {
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentsurl1]]];
}

//画面下のボタン系3
- (IBAction)btn3:(id)sender {
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentsurl2]]];
}

//画面下のボタン系4
- (IBAction)btn4:(id)sender {
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentsurl3]]];
}

//画面下のボタン系5
- (IBAction)btn5:(id)sender {
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentsurl4]]];
}

- (IBAction)backAction:(id)sender {
    if([_wkWebView canGoBack]){
        [_wkWebView goBack];
    }
}

- (IBAction)forwardAction:(id)sender {
    if([_wkWebView canGoForward]){
        [_wkWebView goForward];
    }
}





#pragma mark - scrollViewDelegate
//画面をスワイプした時の方向を取得して判別してる
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _scrollBeginingPoint = [scrollView contentOffset];
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if(translation.y > 0){
        [UIView animateWithDuration:1.0f
                         animations:^{
                             _headerView.frame = CGRectMake(0,   _headerViewPosY, _headerView.bounds.size.width, _headerView.bounds.size.height);
                         }];
    }else{
        [UIView animateWithDuration:1.0f
                         animations:^{
                             _headerView.frame = CGRectMake(0, -80, _headerView.bounds.size.width, _headerView.bounds.size.height);
                         }];
    }
}





@end
