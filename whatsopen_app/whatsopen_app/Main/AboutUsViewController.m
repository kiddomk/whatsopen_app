//
//  AboutUsViewController.m
//  MSNavigationPaneViewController Example
//
//  Created by Eric Horacek on 11/20/12.
//  Copyright (c) 2012-2013 Monospace Ltd. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AboutUsViewController

- (void)loadView
{
    self.webView = [[UIWebView alloc] init];
    self.view = self.webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.webView.backgroundColor = [UIColor blackColor];
    
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.poqstudio.com"]];
    [self.webView loadRequest:URLRequest];
}

@end
