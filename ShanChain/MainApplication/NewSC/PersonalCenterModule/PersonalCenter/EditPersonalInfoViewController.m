//
//  EditPersonalInfoViewController.m
//  ShanChain
//
//  Created by 千千世界 on 2018/11/14.
//  Copyright © 2018年 ShanChain. All rights reserved.
//

#import "EditPersonalInfoViewController.h"
#import "UITextView+Placeholder.h"
#import "EditInfoService.h"

@interface EditPersonalInfoViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameFid;
    
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;
    @property (weak, nonatomic) IBOutlet UILabel *modifyNameLb;
    
@end

@implementation EditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"sc_set_Profile", nil);
    // CHARCTER_MODIFY_URL
    SCCharacterModel_characterInfo *info =  [SCCacheTool shareInstance].characterModel.characterInfo;
    if (!NULLString(info.name)) {
        self.nickNameFid.text = info.name;
    }
    
    if (!NULLString(info.signature)) {
        self.signatureTextView.text = info.signature;
        self.modifyNameLb.text = [NSString stringWithFormat:@"%lu/30",MIN(self.signatureTextView.text.length, 30)];
    }
    
    self.signatureTextView.placeholder = NSLocalizedString(@"sc_set_up", nil);
    self.nickNameFid.placeholder = NSLocalizedString(@"sc_set_name", nil);
    self.signatureTextView.delegate = self;
    [self addRightBarButtonItemWithTarget:self sel:@selector(determine) title:NSLocalizedString(@"sc_login_Confirm", nil) tintColor:Theme_MainThemeColor];
}

- (void)determine{
    if (NULLString(self.nickNameFid.text) && NULLString(self.signatureTextView.text)) {
        [HHTool showError:@"昵称和签名不能为空"];
        return;
    }
    
    NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    SCCharacterModel*characterModel = [SCCacheTool shareInstance].characterModel;
    if (![self.nickNameFid.text isEqualToString:characterModel.characterInfo.name]) {
        [mDic setObject:self.nickNameFid.text forKey:@"name"];
    }
    
    if (![self.signatureTextView.text isEqualToString:characterModel.characterInfo.signature]) {
        [mDic setObject:self.signatureTextView.text forKey:@"signature"];
    }
    
    if (mDic.allKeys.count > 0) {
        weakify(self);
        [EditInfoService sc_editPersonalInfo:mDic callBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                
                characterModel.characterInfo.name = self.nickNameFid.text;
                characterModel.characterInfo.signature = self.signatureTextView.text;
                
                JMSGUserInfo * userInfo = [JMSGUserInfo new];
                userInfo.nickname = self.nickNameFid.text;
                userInfo.signature = self.signatureTextView.text;
                // 更新 极光 用户信息
                [JMSGUser updateMyInfoWithUserInfo:userInfo completionHandler:^(id resultObject, NSError *error) {
                    if (error) {
                        [HHTool showError:@"修改失败"];
                    }else {
                        [weak_self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }
        }];
    }else {
        [HHTool showTip:@"没有修改任何信息" duration:0.5];
    }
   
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 30)
    {
        textView.text = [textView.text substringToIndex:30];
        [HHTool showError:@"字数超出限制"];
    }
    self.modifyNameLb.text = [NSString stringWithFormat:@"%lu/30",MIN(textView.text.length, 30)];
}
    
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    
    if (str.length > 30)
    {
        textView.text = [textView.text substringToIndex:30];
        self.modifyNameLb.text = @"30/30";
        [HHTool showError:@"不能超过30个字"];
        return NO;
    }
    return YES;
}


@end
