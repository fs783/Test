//
//  FirstViewController.h
//  Godina
//
//  Created by Fabio on 13/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DejalActivityView.h"
#import "GANTracker.h"


@interface FirstViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *webView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end