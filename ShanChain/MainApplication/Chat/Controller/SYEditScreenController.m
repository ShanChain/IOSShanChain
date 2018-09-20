//
//  SYEditScreenController.m
//  ShanChain
//
//  Created by krew on 2017/9/15.
//  Copyright © 2017年 krew. All rights reserved.
//

#import "SYEditScreenController.h"

@interface SYEditScreenController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView          *tableView;
@property(nonatomic,strong)UITextView           *textView;
@property(nonatomic,strong)UILabel              *placeholderLabel;

@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation SYEditScreenController
#pragma mark -懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑场景";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(KSCMargin, 13, 55, 55)];
        imgView.userInteractionEnabled = YES;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 8.0f;
        imgView.image = [UIImage imageNamed:@"abs_addanewrole_def_photo_default"];
        self.imgView = imgView;
        [cell addSubview:imgView];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 25, 30, 80, 20)];
        l.textAlignment = NSTextAlignmentLeft;
        l.textColor = RGB(102, 102, 102);
        l.text = @"编辑头像";
        l.font = [UIFont systemFontOfSize:14];
        [cell addSubview:l];
        
        UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - KSCMargin - 6, 35, 6, 12)];
        arrowImgView.image = [UIImage imageNamed:@"abs_meet_btn_enter_default"];
        arrowImgView.userInteractionEnabled = YES;
        [cell addSubview:arrowImgView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(238, 238, 238);
        [cell addSubview:lineView];
        
    }else if (indexPath.row == 1){
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(KSCMargin, 13, 40, 20)];
        l.textColor = RGB(102, 102, 102);
        l.text = @"昵称";
        l.textAlignment = NSTextAlignmentLeft;
        l.font = [UIFont systemFontOfSize:14];
        [cell addSubview:l];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(95, 13, 265 , 20)];
        textField.placeholder = @"请输入昵称";
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont systemFontOfSize:14];
        [cell addSubview:textField];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGB(238, 238, 238);
        [cell addSubview:lineView];
        
    }else{
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 40, 20)];
        l.textAlignment = NSTextAlignmentLeft;
        l.font = [UIFont systemFontOfSize:14];
        l.textColor = RGB(102, 102, 102);
        l.text = @"描述";
        [cell addSubview:l];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(95, 7, 265, 200)];
        textView.textColor = RGB(102, 102, 102);
        textView.textAlignment = NSTextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:14];
        self.textView = textView;
        textView.delegate = self;
        [cell addSubview:textView];
        
        UILabel *placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 200, 17)];
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        placeholderLabel.textColor = RGB(179, 179, 179);
        placeholderLabel.font = [UIFont systemFontOfSize:14];
        placeholderLabel.text = @"请输入场景描述";
        self.placeholderLabel = placeholderLabel;
        [textView addSubview:placeholderLabel];
    }
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 80;
    }else if (indexPath.row == 1){
        return 46;
    }else{
        return 240;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        [self openAlbum];
    }
}

#pragma mark -构造方法
- (void)openAlbum{
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //照片的选取样式还有以下两种
    //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera//调取摄像头
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
}

//选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    SCLog(@"%@",info);
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
//    UIButton *button = (UIButton *)[self.view viewWithTag:1004];
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *image = [resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imgView.image = image;
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)sureAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"" forKey:@"dataString"];
    [params setObject:@"" forKey:@"groupId"];
    [params setObject:@"" forKey:@""];
    [params setObject:@"" forKey:@""];
    
    [[SCNetwork shareInstance]postWithUrl:HXGROUPMODIFY parameters:params success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        SCLog(@"%@",error);
    }];
    
}

#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    if ([self.textView.text length] == 0) {
        [self.placeholderLabel setHidden:NO];
    }else{
        [self.placeholderLabel setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
