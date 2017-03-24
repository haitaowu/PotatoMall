//
//  CancelOrderCell.m
//  PotatoMall
//
//  Created by taotao on 23/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "CancelOrderCell.h"
#import "NSString+Extentsion.h"

@interface CancelOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *unpayView;
@property (weak, nonatomic) IBOutlet UIButton *payOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *unpayCancelBtn;
@property (weak, nonatomic) IBOutlet UIView *prepareTransView;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmRecivedBtn;
@property (weak, nonatomic) IBOutlet UIView *finishOrderView;
@property (weak, nonatomic) IBOutlet UIButton *deleteOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyAgainBtn;
@property (weak, nonatomic) IBOutlet UIView *confirmCancelView;
@property (weak, nonatomic) IBOutlet UIButton *reBuyBtn;
@property (weak, nonatomic) IBOutlet UIView *verifyView;
@end

@implementation CancelOrderCell
#pragma mark - override methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 5;
    
    //unpay view cancel btn
    self.unpayCancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.unpayCancelBtn.layer.borderWidth = 1;
    self.unpayCancelBtn.layer.masksToBounds = YES;
    self.unpayCancelBtn.layer.cornerRadius = 5;
    
    //pay button
    self.payOrderBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.payOrderBtn.layer.borderWidth = 1;
    self.payOrderBtn.layer.masksToBounds = YES;
    self.payOrderBtn.layer.cornerRadius = 5;
    
    
    // view cancel btn
    self.cancelOrderBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelOrderBtn.layer.borderWidth = 1;
    self.cancelOrderBtn.layer.masksToBounds = YES;
    self.cancelOrderBtn.layer.cornerRadius = 5;
    
    // button
    self.confirmRecivedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.confirmRecivedBtn.layer.borderWidth = 1;
    self.confirmRecivedBtn.layer.masksToBounds = YES;
    self.confirmRecivedBtn.layer.cornerRadius = 5;
    
    // delete btn
    self.deleteOrderBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.deleteOrderBtn.layer.borderWidth = 1;
    self.deleteOrderBtn.layer.masksToBounds = YES;
    self.deleteOrderBtn.layer.cornerRadius = 5;
    
    //buyAgain button
    self.buyAgainBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.buyAgainBtn.layer.borderWidth = 1;
    self.buyAgainBtn.layer.masksToBounds = YES;
    self.buyAgainBtn.layer.cornerRadius = 5;
    
    //reBuyBtn button
    self.reBuyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.reBuyBtn.layer.borderWidth = 1;
    self.reBuyBtn.layer.masksToBounds = YES;
}


#pragma mark -  setter and getter methods 
- (void)setModel:(OrderModel *)model
{
    //订单状态 0待确认 1未付款 2待提货 3已完成  -1为全部
    _model = model;
    self.dateLabel.text = model.createTime;
    if ([model.orderStatus isEqualToString:@"0"]) {
        self.cancelBtn.hidden = NO;
        self.unpayView.hidden = YES;
        self.prepareTransView.hidden = YES;
        self.finishOrderView.hidden = YES;
        self.confirmCancelView.hidden = YES;
        self.verifyView.hidden = YES;
    }else if ([model.orderStatus isEqualToString:@"1"]) {
        self.unpayView.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.prepareTransView.hidden = YES;
        self.finishOrderView.hidden = YES;
        self.confirmCancelView.hidden = YES;
        self.verifyView.hidden = YES;
    }else if ([model.orderStatus isEqualToString:@"2"]) {
        self.prepareTransView.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.unpayView.hidden = YES;
        self.finishOrderView.hidden = YES;
        self.confirmCancelView.hidden = YES;
        self.verifyView.hidden = YES;
    }else if ([model.orderStatus isEqualToString:@"3"]) {
        self.finishOrderView.hidden = NO;
        self.prepareTransView.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.unpayView.hidden = YES;
        self.confirmCancelView.hidden = YES;
        self.verifyView.hidden = YES;
    }else if ([model.orderStatus isEqualToString:@"8"]) {
        self.confirmCancelView.hidden = NO;
        self.finishOrderView.hidden = YES;
        self.prepareTransView.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.unpayView.hidden = YES;
        self.verifyView.hidden = YES;
    }else if ([model.orderStatus isEqualToString:@"14"]) {
        self.verifyView.hidden = NO;
        self.confirmCancelView.hidden = YES;
        self.finishOrderView.hidden = YES;
        self.prepareTransView.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.unpayView.hidden = YES;
    }else{
        self.verifyView.hidden = YES;
        self.confirmCancelView.hidden = YES;
        self.finishOrderView.hidden = YES;
        self.prepareTransView.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.unpayView.hidden = YES;
    }
}

#pragma mark - selectors
- (IBAction)tapCancelBtn:(id)sender {
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
}

//支付订单
- (IBAction)tapPayOrderBtn:(id)sender {
    if (self.payOrderBlock != nil) {
        self.payOrderBlock();
    }
}

//退单
- (IBAction)tapCancelOrderBtn:(id)sender {
}

//确定提货
- (IBAction)tapConfirmRecivedBtn:(id)sender {
}


//删除订单
- (IBAction)tapDeleteOrderBtn:(id)sender {
    if (self.deleteOrderBlock != nil) {
        self.deleteOrderBlock(self.model);
    }
}

//再次购买
- (IBAction)tapBuyAgainBtn:(id)sender {
    if (self.reBuyBlock != nil) {
        self.reBuyBlock(self.model);
    }
}

//重新购买
- (IBAction)tapReBuyBtn:(id)sender {
    if (self.reBuyBlock != nil) {
        self.reBuyBlock(self.model);
    }
}

@end
