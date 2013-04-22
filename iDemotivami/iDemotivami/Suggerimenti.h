//
//  SecondViewController.h
//  iDemotivami
//
//  Created by FabioS on 16/04/13.
//  Copyright (c) 2013 Fabio Simi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Suggerimenti : UIViewController <UITextViewDelegate, UITextFieldDelegate> {

    UITextView *txtAsuggerimenti;
    UILabel *nome;
    UILabel *suggerimento;
    UITextField *campoNome;
    }



@property (nonatomic, retain) IBOutlet UITextView *txtAsuggerimenti;
@property (nonatomic, retain) IBOutlet UITextField *campoNome;
@property(nonatomic, assign) id<UITextFieldDelegate> delegate;
-(IBAction)inviaSuggerimentoBtn:(id)sender;

@end
