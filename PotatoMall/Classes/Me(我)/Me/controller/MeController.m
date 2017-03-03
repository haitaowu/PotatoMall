//
//  MeController.m
//  PotatoMall
//
//  Created by taotao on 25/02/2017.
//  Copyright © 2017 taotao. All rights reserved.
//

#import "MeController.h"
#import "MeMenuCell.h"
#import "AppInfoHelper.h"

#define kSaleSectionIndex               0
#define kChargeSectionIndex             3
#define kSettingSectionIndex            4

static NSString *MeMenuCellID = @"MeMenuCellID";


@interface MeController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *menusData;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUserInfoUI];
}

#pragma mark - setup UI 
- (void)setupTableview
{
    UINib *menuCellNib = [UINib nibWithNibName:@"MeMenuCell" bundle:nil];
    [self.tableView registerNib:menuCellNib forCellReuseIdentifier:MeMenuCellID];
    self.menusData = [AppInfoHelper arrayWithPlistFile:@"MeMenus"];
    [self.tableView reloadData];
}

- (void)updateUserInfoUI
{
    [[UserModelUtil sharedInstance] avatarImageWithBlock:^(UIImage *img) {
        self.avatarView.image = img;
    }];
    UserModel *model = [UserModelUtil sharedInstance].userModel;
    self.roleLabel.text = [UserModelUtil userRoleWithType:model.userType];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menusData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MeMenuCellID];
    NSDictionary *menuData = self.menusData[indexPath.section];
    [cell setMenuData:menuData indexPath:indexPath];
    return cell;
}


#pragma mark - UITableView --- Table view  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == kSaleSectionIndex) {
        return 16;
    }else if (section == kChargeSectionIndex) {
        return 16;
    }else if (section == kSettingSectionIndex) {
        return 16;
    }else{
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *menuData = self.menusData[indexPath.section];
    NSString *segue = [menuData objectForKey:kSegueKey];
    [self performSegueWithIdentifier:segue sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end
