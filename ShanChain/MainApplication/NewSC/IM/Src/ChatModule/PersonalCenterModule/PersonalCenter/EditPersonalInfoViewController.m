//
//  EditPersonalInfoViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "EditPersonalInfoViewController.h"
#import "UITextView+Placeholder.h"

@interface EditPersonalInfoViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameFid;
    
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;
    @property (weak, nonatomic) IBOutlet UILabel *modifyNameLb;
    
@end

@implementation EditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signatureTextView.placeholder = @"请输入签名...";
    self.signatureTextView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 20)
    {
        textView.text = [textView.text substringToIndex:20];
    }
    self.modifyNameLb.text = [NSString stringWithFormat:@"%ld/20",MIN(textView.text.length, 20)];
}
    
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > 20)
    {
        textView.text = [textView.text substringToIndex:20];
        self.modifyNameLb.text = @"20/20";
        return NO;
    }
    return YES;
}

@end
