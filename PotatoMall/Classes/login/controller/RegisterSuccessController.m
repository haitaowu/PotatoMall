//
//  RegisterSuccessController.m
//  PotatoMall
//
//  Created by taotao on 03/03/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "RegisterSuccessController.h"

@interface RegisterSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RegisterSuccessController

#pragma mark - override methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.desTitle;
}

- (void)tapBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapShowHomeItem:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    
}


@end
