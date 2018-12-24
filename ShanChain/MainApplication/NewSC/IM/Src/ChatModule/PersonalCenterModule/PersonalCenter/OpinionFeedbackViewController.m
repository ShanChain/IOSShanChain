//
//  OpinionFeedbackViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/12/13.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "OpinionFeedbackViewController.h"
#import "UITextView+Placeholder.h"

@interface OpinionFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation OpinionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"sc_Feedback", nil),
    self.textView.placeholder = @"请输入您要反馈的建议...";
    
}

- (IBAction)submitAction:(UIButton *)sender {
    if (NULLString(self.textView.text)) {
        [HHTool showError:@"反馈内容不能为空"];
        return;
    }
    
    NSString  *dataString = @{@"title":@"用户反馈",@"disc":self.textView.text,@"type":@"1"}.mj_JSONString;
    [[SCNetwork shareInstance]v1_postWithUrl:Feedback_URL params:@{@"dataString":dataString,@"userId":[SCCacheTool shareInstance].getCurrentUser} showLoading:YES callBlock:^(HHBaseModel *baseModel, NSError *error) {
        if (!error) {
            [HHTool showSucess:baseModel.message];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}


@end
