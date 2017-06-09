//
//  YEvaluteOrderViewController.m
//  shopsN
//
//  Created by imac on 2016/12/8.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "YEvaluteOrderViewController.h"
#import "YEvaluteOrderCell.h"


@interface YEvaluteOrderViewController ()<UITableViewDelegate,UITableViewDataSource,YEvaluteOrderCellDelegate>

@property (strong,nonatomic) UITableView *tableV;

@property (strong,nonatomic) NSMutableArray *dataArr;

/**  弹出框 */
@property (strong,nonatomic) UIView *iconImageView;

@property (nonatomic) NSInteger chooseIndex;

@end

@implementation YEvaluteOrderViewController


//-(void)getdata{
//    _dataArr = [NSMutableArray array];
//    for (int i=0; i<2; i++) {
//        YOrderEvalueModel *model = [[YOrderEvalueModel alloc]init];
//        model.goodUrl = @"";
//        model.imageArr = [NSMutableArray array];
//        [_dataArr addObject:model];
//    }
//    [_tableV reloadData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价商品";
    _chooseIndex = 0;
    [self initView];
//    [self getdata];
}

-(void)initView{
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64-50)];
    [self.view addSubview:_tableV];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundColor = [UIColor clearColor];
    _tableV.separatorColor = [UIColor clearColor];

    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(_tableV), __kWidth, 50)];
    [self.view addSubview:sureBtn];
    sureBtn.backgroundColor = __DefaultColor;
    sureBtn.titleLabel.font = MFont(16);
    [sureBtn setTitle:@"提交评价" forState:BtnNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:BtnTouchUpInside];
}

#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YEvaluteOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YEvaluteOrderCell"];
    if (!cell) {
        cell = [[YEvaluteOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YEvaluteOrderCell"];
    }
    YOrderEvalueModel *model = _list[indexPath.row];
    cell.model = model;
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}
#pragma mark ==YEvaluteOrderCellDelegate==
-(void)giveStar:(NSInteger)star index:(NSInteger)tag{
    YOrderEvalueModel *model = _list[tag];
    model.star = [NSString stringWithFormat:@"%ld",star];
    [_dataArr replaceObjectAtIndex:tag withObject:model];
}

-(void)addPhotos:(NSInteger)tag{
    _chooseIndex = tag;
    [self addImage:tag];
}

-(void)evaluteText:(NSString *)string index:(NSInteger)tag{
    YOrderEvalueModel *model = _list[tag];
    model.evalue = string;
    [_dataArr replaceObjectAtIndex:tag withObject:model];
}


#pragma mark ===== 添加图片 =====

-(void)addImage:(NSInteger)tag{
    //弹出框
    _iconImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    _iconImageView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:_iconImageView];
    //*** 按设计修改后内容
    NSArray *array = @[@"拍照", @"我的相册", @"取消"];
    //1 菜单视图 选择拍照或相册
    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(10, __kHeight-172, __kWidth-20, 102)];
    chooseView.backgroundColor = HEXCOLOR(0xffffff);
    [_iconImageView addSubview:chooseView];
    chooseView.layer.cornerRadius = 10.0f;

    //1.1 中间分隔线
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, CGRectW(chooseView), 1)];
    [chooseView addSubview:lineIV];
    lineIV.backgroundColor = HEXCOLOR(0xdedede);

    //1.2 选择拍照或相册 按钮
    //    按钮颜色 color(0 84 255)  (0x0051ff)
    for (NSInteger i=0; i<array.count-1; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i*52, CGRectW(chooseView), 50)];
        //        btn.backgroundColor = HEXCOLOR(0xf1f1f1);
        [btn setTitleColor:HEXCOLOR(0x0051ff) forState:BtnNormal];
        //        btn.titleLabel.font = MFont(15);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(iconBtnAction:) forControlEvents:BtnTouchUpInside];
        btn.tag = 160+i;
        [chooseView addSubview:btn];
    }


    //2 菜单视图 选择 取消
    UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectYH(chooseView)+10, __kWidth-20, 50)];
    cancelView.backgroundColor = HEXCOLOR(0xffffff);
    [_iconImageView addSubview:cancelView];
    cancelView.layer.cornerRadius = 10.0f;

    //2.1 按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectW(cancelView), 50)];
    [cancelView addSubview:cancelBtn];
    [cancelBtn setTitleColor:HEXCOLOR(0x0051ff) forState:BtnNormal];
    //  cancelBtn.titleLabel.font = MFont(15);
    [cancelBtn setTitle:array[2] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(iconBtnAction:) forControlEvents:BtnTouchUpInside];
    cancelBtn.tag = 162;



}

- (void)iconBtnAction:(UIButton *)btn {
    switch (btn.tag - 160) {
        case 0: {
            NSLog(@"拍照");
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
            pickerVC.delegate = self;
            //选择照片数据源 ---默认是相册
            pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerVC animated:YES completion:nil];
        }


            break;
        case 1: {
            NSLog(@"从相册获取");
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
            //想要知道选择的图片
            pickerVC.delegate = self;
            //开启编辑状态
            pickerVC.allowsEditing = YES;
            [self presentViewController:pickerVC animated:YES completion:nil];
            [_iconImageView removeFromSuperview];
        }

            break;
        default:
            NSLog(@"取消");
            [_iconImageView removeFromSuperview];
            break;
    }
}

#pragma mark - 更换头像Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *goodImage  = info[UIImagePickerControllerOriginalImage];
    if (picker.allowsEditing) {
        goodImage = info[UIImagePickerControllerEditedImage];
    }
    YOrderEvalueModel *model = _dataArr[_chooseIndex];
    [model.imageArr addObject:goodImage];
    [_list replaceObjectAtIndex:_chooseIndex withObject:model];

    [picker dismissViewControllerAnimated:YES completion:nil];
    //保存图片进入沙盒中
    [_tableV reloadData];
}

#pragma mark ==确认提交==
-(void)sureAction{
    NSLog(@"确认提交");
   __block BOOL isEvalue = YES;
    WK(weakSelf)
    for (YOrderEvalueModel *model in _list) {
        NSMutableArray *datas = [NSMutableArray array];
        for (UIImage *image in model.imageArr) {
           NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [datas addObject:imageData];
        }
        [JKHttpRequestService POST:@"Order/commentAdd" Params:@{@"app_user_id":[UdStorage getObjectforKey:Userid],@"content":model.evalue,@"status":model.star,@"goods_orders_id":model.orderId,@"goods_id":model.goodId} NSArray:datas key:@"img" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            if (succe) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSArray *arr = @[@"1"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"OrderData" object:arr];
            }else{
                isEvalue= NO;
            }
        } failure:^(NSError *error) {
            isEvalue= NO;
        } animated:NO];
    }
    if (!isEvalue) {
        [SXLoadingView showAlertHUD:@"提交失败请重试" duration:SXLoadingTime];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end