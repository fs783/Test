//
//  AltroViewController.h
//  Godina
//
//  Created by Fabio on 17/09/12.
//  Copyright (c) 2012 Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AltroViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *altro;
   
}
@property (strong, nonatomic) IBOutlet UIWebView *altro;

@end
