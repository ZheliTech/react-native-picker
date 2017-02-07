//
//  RCTBEEPickerManager.m
//  RCTBEEPickerManager
//
//  Created by MFHJ-DZ-001-417 on 16/9/6.
//  Copyright © 2016年 MFHJ-DZ-001-417. All rights reserved.
//

#import "RCTBEEPickerManager.h"
#import "BzwPicker.h"
#import "RCTEventDispatcher.h"
#import "UIColor+BEEAdditions.h"

@interface BzwPickerView : UIView

@end

@implementation BzwPickerView

@end

@interface RCTBEEPickerManager()

@property (nonatomic, strong) UIView *pickerView;
@property(nonatomic,strong)BzwPicker *pick;
@property(nonatomic,assign)float height;
@property(nonatomic,weak)UIWindow * window;

@end

@implementation RCTBEEPickerManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRNReload) name:RCTReloadNotification object:nil];
    }
    return self;
}

-(void)onRNReload
{
    [self hide];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(_init:(NSDictionary *)indic){
    if (_pickerView) {
        [self _releasePicker];
    }
    NSLog(@"%@", indic);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    });
    
    self.window = [UIApplication sharedApplication].keyWindow;
    
    NSString *pickerConfirmBtnText=indic[@"pickerConfirmBtnText"];
    NSString *pickerCancelBtnText=indic[@"pickerCancelBtnText"];
    NSString *pickerTitleText=indic[@"pickerTitleText"];
    NSArray *pickerConfirmBtnColor=indic[@"pickerConfirmBtnColor"];
    NSArray *pickerCancelBtnColor=indic[@"pickerCancelBtnColor"];
    NSArray *pickerTitleColor=indic[@"pickerTitleColor"];
    NSArray *pickerToolBarBg=indic[@"pickerToolBarBg"];
    NSArray *pickerBg=indic[@"pickerBg"];
    NSArray *maskBg=indic[@"maskBg"];
    NSArray *separatorColor=indic[@"separatorColor"];
    NSArray *selectArry=indic[@"selectedValue"];
    NSArray *weightArry=indic[@"wheelFlex"];
    NSString *pickerToolBarFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerToolBarFontSize"]];
    NSString *pickerFontSize=[NSString stringWithFormat:@"%@",indic[@"pickerFontSize"]];
    NSArray *pickerFontColor=indic[@"pickerFontColor"];
    
    id pickerData=indic[@"pickerData"];
    
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    
    dataDic[@"pickerData"]=pickerData;
    
    _pickerView = [[BzwPickerView alloc] initWithFrame:[self _getWindow].bounds];
    _pickerView.backgroundColor = [UIColor bee_colorWith:maskBg];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onTapBlank)];
    [_pickerView addGestureRecognizer:tapRecognizer];
    
    _pick=[[BzwPicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250) dic:dataDic leftStr:pickerCancelBtnText centerStr:pickerTitleText rightStr:pickerConfirmBtnText topbgColor:pickerToolBarBg bottombgColor:pickerBg leftbtnbgColor:pickerCancelBtnColor rightbtnbgColor:pickerConfirmBtnColor centerbtnColor:pickerTitleColor selectValueArry:selectArry weightArry:weightArry separatorColor:separatorColor pickerToolBarFontSize:pickerToolBarFontSize pickerFontSize:pickerFontSize pickerFontColor:pickerFontColor];
    __weak typeof(self) weakSelf = self;
    _pick.dismissBlock = ^{
        [weakSelf hide];
    };
    [_pickerView addSubview:_pick];
    
    _pick.bolock=^(NSDictionary *backinfoArry){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.bridge.eventDispatcher sendAppEventWithName:@"pickerEvent" body:backinfoArry];
        });
    };
}

- (UIWindow *)_getWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

- (void)_onTapBlank {
    [_pick cancleAction];
}

- (void)_releasePicker {
    [_pickerView removeFromSuperview];
    _pickerView = nil;
    _pick = nil;
}

RCT_EXPORT_METHOD(show){
    if (_pick && _pick.frame.origin.y != _pickerView.frame.size.height-250) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self _getWindow] addSubview:_pickerView];
            
            [UIView animateWithDuration:.3 animations:^{
                [_pick setFrame:CGRectMake(0, _pickerView.frame.size.height-250, SCREEN_WIDTH, 250)];
            }];
        });
    }return;
}

RCT_EXPORT_METHOD(hide){
    if (_pick && _pick.frame.origin.y != _pickerView.frame.size.height) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                [_pick setFrame:CGRectMake(0, _pickerView.frame.size.height, SCREEN_WIDTH, 250)];
            } completion:^(BOOL finished) {
                [self _releasePicker];
            }];
        });
    }return;
}

RCT_EXPORT_METHOD(select: (NSArray*)data){

    if (self.pick) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _pick.selectValueArry = data;
            [_pick selectRow];
        });
    }return;
}

RCT_EXPORT_METHOD(isPickerShow:(RCTResponseSenderBlock)getBack){
    if (self.pick) {
        CGFloat pickY=_pick.frame.origin.y;
        if (pickY==_pickerView.frame.size.height) {
            getBack(@[@YES]);
        } else {
            getBack(@[@NO]);
        }
    } else {
        getBack(@[@"picker不存在"]);
    }
}

@end
