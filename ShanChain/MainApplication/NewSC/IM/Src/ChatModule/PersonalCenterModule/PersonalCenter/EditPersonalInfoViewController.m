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
    self.title = @"修改个人资料";
    // CHARCTER_MODIFY_URL
    SCCharacterModel_characterInfo *info =  [SCCacheTool shareInstance].characterModel.characterInfo;
    if (!NULLString(info.name)) {
        self.nickNameFid.text = info.name;
    }
    
    if (!NULLString(info.signature)) {
        self.signatureTextView.text = info.signature;
         self.modifyNameLb.text = [NSString stringWithFormat:@"%ld/30",MIN(self.signatureTextView.text.length, 30)];
    }
    
    self.signatureTextView.placeholder = @"请输入签名...";
    self.signatureTextView.delegate = self;
    [self addRightBarButtonItemWithTarget:self sel:@selector(determine) title:@"确定" tintColor:[UIColor whiteColor]];
}

- (void)determine{
    if (NULLString(self.nickNameFid.text) && NULLString(self.signatureTextView.text)) {
        [HHTool showError:@"昵称和签名不能为空"];
        return;
    }
    
    NSMutableDictionary  *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    SCCharacterModel*characterModel = [SCCacheTool shareInstance].characterModel;
    if (![self.nickNameFid.text isEqualToString:characterModel.characterInfo.headImg]) {
        [mDic setObject:self.nickNameFid.text forKey:@"name"];
    }
    
    if (![self.nickNameFid.text isEqualToString:characterModel.characterInfo.signature]) {
        [mDic setObject:self.signatureTextView.text forKey:@"signature"];
    }
    
    if (mDic.allKeys.count > 0) {
        weakify(self);
        [EditInfoService sc_editPersonalInfo:mDic callBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [weak_self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
   
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 30)
    {
        textView.text = [textView.text substringToIndex:30];
        [HHTool showError:@"字数超出限制"];
    }
    self.modifyNameLb.text = [NSString stringWithFormat:@"%ld/30",MIN(textView.text.length, 30)];
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
