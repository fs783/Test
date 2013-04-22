//
//  FirstViewController.h
//  iDemotivami
//
//  Created by FabioS on 16/04/13.
//  Copyright (c) 2013 Fabio Simi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home : UIViewController  {

    UITextView *textArea;
	NSArray *elencoFrasi;
	int fraseCorrente;

}

@property (nonatomic, retain) IBOutlet UITextView *textArea;

@end
