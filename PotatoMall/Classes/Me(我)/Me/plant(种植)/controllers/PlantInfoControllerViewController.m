//
//  PlantInfoControllerViewController.m
//  PotatoMall
//
//  Created by lipengcheng on 2017/9/6.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "PlantInfoControllerViewController.h"
#import "plantmodel.h"
#import "BRPickerView.h"

@interface PlantInfoControllerViewController ()
@end

@implementation PlantInfoControllerViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"种植信息";
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 280)];
//
//    //指定数据源和委托
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    if([_canclick isEqualToString:@"1"]){
        self.addresstextfield.enabled=false ;
        self.numtextfield.enabled=false ;
        [self.buttoncell setHidden:YES];
    }
    // Do any additional setup after loading the view.
}



-(void)viewWillAppear:(BOOL)animated{
    [self findSysDictByType:[self Paramstype:@"1"]];
    [self findSysDictByType:[self Paramstype:@"2"]];
    [self findSysDictByType:[self Paramstype:@"3"]];
}

-(void)viewDidAppear:(BOOL)animated{
//    NSDictionary *parama=[self whetherFillPlatInfoParams];
//    [self whetherFillPlatInfo:parama];
    
    NSDictionary *parama=[self userParams];
    [self detailUserPlat:parama];
}

#pragma mark - Privates
- (NSDictionary *)whetherFillPlatInfoParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (NSDictionary *)userParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    return params;
}

- (NSDictionary *)Paramstype:(NSString*)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = type;
    return params;
}
//
- (void)setupPickViewWithTitles:(NSArray*)titles title:(NSString*)title defaultTitle:(NSString*)defaultTitle block:(void(^)(NSInteger))block
{
    __weak typeof(self) weakSelf = self;
//    [BRStringPickerView showStringPickerWithTitle:title dataSource:titles defaultSelValue:defaultTitle isAutoSelect:YES resultBlock:^(id selectValue) {
//        //        weakSelf.field.text = selectValue;
//        [field setTitle:selectValue forState:UIControlStateNormal];
//    }];
    [BRStringPickerView showSPickerWithTitle:title dataSource:titles resultBlock:^(NSInteger idx, id selectValue) {
        block(idx);
//        [field setTitle:selectValue forState:UIControlStateNormal];
    }];
}


- (NSDictionary *)plantParams
{
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kUserIdKey] = model.userId;
    params[@"cropName"] = cropName;
    params[@"platType"] = platType;
    params[@"platSource"] = platSource;
    params[@"platArea"] = self.numtextfield.text;
    params[@"platAddress"] = self.addresstextfield.text;
    return params;
}


#pragma mark - requset server
//- (void)whetherFillPlatInfo:(NSDictionary*)params
//{
//    if ([RequestUtil networkAvaliable] == NO) {
//    }else{
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
//        NSString *subUrl = @"/user_union/whetherUserUnion";
//        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
//        
//        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
//            if (status == StatusTypSuccess) {
////                [SVProgressHUD showSuccessWithStatus:msg];
//                data=[plantmodel plantWithData:data];
//                
//                NSLog(@"data==%@",data);
//                if([data objectForKey:@"unionId"]){
//                    NSDictionary *parama=[self userParams];
//                    [self detailUserPlat:parama];
//                }
//            }else{
//                [SVProgressHUD showErrorWithStatus:msg];
//            }
//        } reqFail:^(int type, NSString *msg) {
//            [SVProgressHUD showErrorWithStatus:msg];
//        }];
//    }
//}

//检查是否加入联全社
//- (void)checkUserUnionState
//{
//    NSDictionary *unionParams =[self whetherFillPlatInfoParams];
//    [self whetherUserUnion:unionParams resultBlock:^(NSString *uionId, BOOL reqState) {
//        if (reqState == YES) {
//            if ((uionId == nil) || (uionId.length <= 0)){
//                self.unionId = nil;
//            }else{
//                self.unionId = uionId;
//            }
//        }else{
//            self.unionId = nil;
//            HTLog(@"request timeout");
//        }
//    }];
//}

- (void)detailUserPlat:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user/detailUserPlat";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            [SVProgressHUD dismiss];
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                
                data=[plantmodel plantWithData:data];
                [self.addresstextfield setText:[data objectForKey:@"platAddress"]];
                [self.numtextfield setText:[NSString stringWithFormat:@"%@",[data objectForKey:@"platArea"]]];
                
                for(int i=0;i<[type0 count];i++){
                    plantmodel *Model =  type0[i];
                    NSString *cropName=[NSString stringWithFormat:@"%@",[data objectForKey:@"cropName"]];

                    if([Model.uid isEqualToString:cropName]){
                        
                        [self.lastmodelbutton setTitle:Model.name forState:UIControlStateNormal];
                    }
                }
                
                for(int i=0;i<[type1 count];i++){
                    plantmodel *Model =  type1[i];
                    NSString *platType=[NSString stringWithFormat:@"%@",[data objectForKey:@"platType"]];
                    
                    if([Model.uid isEqualToString:platType]){
                        
                        [self.zhongsubutton setTitle:Model.name forState:UIControlStateNormal];
                    }
                }
                
                for(int i=0;i<[type2 count];i++){
                    plantmodel *Model =  type2[i];
                    NSString *platSource=[NSString stringWithFormat:@"%@",[data objectForKey:@"platSource"]];
        
                          
                    if([Model.uid isEqualToString:platSource]){
                        
                        [self.laiyuanbutton setTitle:Model.name forState:UIControlStateNormal];
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

//查询字典
- (void)findSysDictByType:(NSDictionary*)params
{
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/system/findSysDictByType";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:params reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
//                [SVProgressHUD showSuccessWithStatus:msg];
                
                if([[params objectForKey:@"type"]isEqualToString:@"1"]){
                    type0=[plantmodel plantWithDataArray:data];
                }
                if([[params objectForKey:@"type"]isEqualToString:@"2"]){
                    type1=[plantmodel plantWithDataArray:data];
                }
                if([[params objectForKey:@"type"]isEqualToString:@"3"]){
                    type2=[plantmodel plantWithDataArray:data];
                }
//                NSLog(@"type0==%@",type0);
                
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}



#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

////指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
 //第一个展示字母、第二个展示数字
}
//
//
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag==0){
        return [type0 count];
    }
    if(pickerView.tag==1){
        return [type1 count];
    }
    if(pickerView.tag==2){
        return [type2 count];
    }
    return 0;
}
//
//
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    if(pickerView.tag==0){
        plantmodel *Model =  type0[row];
        return Model.name;
    }
    if(pickerView.tag==1){
        plantmodel *Model =  type1[row];
        return Model.name;
    }
    if(pickerView.tag==2){
        plantmodel *Model =  type2[row];
        return Model.name;
    }
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    // 使用一个UIAlertView来显示用户选中的列表项
    [pickerView removeFromSuperview];
    if(pickerView.tag==0){
        
        plantmodel *Model =  type0[row];
        [self.lastmodelbutton setTitle:Model.name forState:UIControlStateNormal];
        cropName=Model.uid;
        
        
    }
    if(pickerView.tag==1){
        
        plantmodel *Model =  type1[row];
        [self.zhongsubutton setTitle:Model.name forState:UIControlStateNormal];
        platType=Model.uid;
    }
    if(pickerView.tag==2){
        
        plantmodel *Model =  type2[row];
        [self.laiyuanbutton setTitle:Model.name forState:UIControlStateNormal];
        platSource=Model.uid;
    }
    
}



#pragma mark - Selectors
//上茬作物
- (IBAction)lastbuttonclick:(id)sender {
//    if([_canclick isEqualToString:@"1"]){
//        return;
//    }
//    _pickerView.tag=0;
//    [_pickerView reloadAllComponents];
//    [self.view addSubview:_pickerView];
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (plantmodel *model in type0) {
        [array addObject:model.name];
    }
    if ([array count] > 0){
        NSArray *titles = array;
        NSString *title = @"上茬作物";
        NSString *defaultTitle = [array firstObject];
        __weak typeof(self) weakSelf = self;
        [self setupPickViewWithTitles:titles title:title defaultTitle:defaultTitle block:^(NSInteger idx) {
            plantmodel *model = type0[idx];
            [weakSelf.lastmodelbutton setTitle:model.name forState:UIControlStateNormal];
            cropName=model.uid;
        }];
    }
}

//种署
- (IBAction)zhongsuclick:(id)sender {
//    if([_canclick isEqualToString:@"1"]){
//        return;
//    }
//    _pickerView.tag=1;
//    [_pickerView reloadAllComponents];
//    [self.view addSubview:_pickerView];
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (plantmodel *model in type1) {
        [array addObject:model.name];
    }
    if ([array count] > 0){
        NSArray *titles = array;
        NSString *title = @"种薯";
        NSString *defaultTitle = [array firstObject];
        __weak typeof(self) weakSelf = self;
        [self setupPickViewWithTitles:titles title:title defaultTitle:defaultTitle block:^(NSInteger idx) {
            plantmodel *model = type1[idx];
            [weakSelf.zhongsubutton setTitle:model.name forState:UIControlStateNormal];
            platType=model.uid;
        }];
    }
}

//种薯来源
- (IBAction)laiyuanclick:(id)sender {
//    if([_canclick isEqualToString:@"1"]){
//        return;
//    }
//    _pickerView.tag=2;
//    [_pickerView reloadAllComponents];
//    [self.view addSubview:_pickerView];
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (plantmodel *model in type2) {
        [array addObject:model.name];
    }
    if ([array count] > 0){
        NSArray *titles = array;
        NSString *title = @"种薯来源";
        NSString *defaultTitle = [array firstObject];
        __weak typeof(self) weakSelf = self;
        [self setupPickViewWithTitles:titles title:title defaultTitle:defaultTitle block:^(NSInteger idx) {
            plantmodel *model = type2[idx];
            [weakSelf.laiyuanbutton setTitle:model.name forState:UIControlStateNormal];
            platSource=model.uid;
        }];
    }
}

//提交用户修改数据
- (IBAction)submitinfo:(id)sender {
    [self.view endEditing:YES];
    if ([RequestUtil networkAvaliable] == NO) {
        [self.tableView reloadData];
    }else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        NSString *subUrl = @"/user/saveOrUpdateUserPlat";
        NSString *reqUrl = [NSString stringWithFormat:@"%@%@",BASEURL,subUrl];
        
        [RequestUtil POSTWithURL:reqUrl params:[self plantParams] reqSuccess:^(int status, NSString *msg, id data) {
            if (status == StatusTypSuccess) {
                [SVProgressHUD showSuccessWithStatus:msg];
            }else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } reqFail:^(int type, NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    }
}
@end
