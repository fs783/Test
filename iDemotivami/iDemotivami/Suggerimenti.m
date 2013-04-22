//
//  SecondViewController.m
//  iDemotivami
//
//  Created by FabioS on 16/04/13.
//  Copyright (c) 2013 Fabio Simi. All rights reserved.
//

#import "Suggerimenti.h"

@interface Suggerimenti ()

@end

@implementation Suggerimenti



@synthesize campoNome, txtAsuggerimenti;



// questo metodo permette alla tastiera di chiudersi

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField{
    [textField resignFirstResponder];
    return YES;
}

    
- (void)viewDidLoad
{
    [super viewDidLoad];
      
    // imposto i delegati campo testo per nascondere tastiera
    
    campoNome.delegate = self;
    txtAsuggerimenti.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)inviaSuggerimentoBtn:(id)sender  {


}

@end
