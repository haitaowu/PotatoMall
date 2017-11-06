//
//  HTPickedImagesView.m
//  RoseDecoration
//
//  Created by taotao on 2017/10/10.
//  Copyright © 2017年 taotao. All rights reserved.
//

#import "HTPickedImagesView.h"
#import "LGPhoto.h"
#import "ImgItemCell.h"

#define kItemsColumn            3


static NSString * ImgItemCellID = @"ImgItemCellID";


@interface HTPickedImagesView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LGPhotoPickerViewControllerDelegate>
@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,assign) CGFloat imgViewHeight;
@property(nonatomic,strong) NSMutableArray *imgs;
@end

@implementation HTPickedImagesView

#pragma mark - override methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - public methods
- (CGFloat)itemsWHeight
{
    CGFloat wh = self.width / kItemsColumn;
    return wh;
}

#pragma mark - private methods
- (void)setupUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = flowLayout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    UINib *collectionNib = [UINib nibWithNibName:@"ImgItemCell"   bundle:nil];
    [self.collectionView registerNib:collectionNib forCellWithReuseIdentifier:ImgItemCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //
    self.imgs = [NSMutableArray array];
    [self.imgs addObject:[UIImage imageNamed:@"ic_choice_receipt_address_edit"]];
    [self updateImgsCount];
}

- (void)updateImgsCount
{
    [self.collectionView reloadData];
    [self resetPickerRowHeight];
}

- (ItemType)itemTypeForIndexPath:(NSIndexPath*)indexPath
{
    NSInteger lastImgIdx = self.imgs.count - 1;
    if (lastImgIdx == indexPath.item) {
        return  ItemTypeAdd;
    }else{
        return  ItemTypeImg;
    }
}

- (void)resetPickerRowHeight
{
    CGFloat itemWH = [self itemsWHeight];
    self.imgViewHeight = itemWH  * ((kItemsColumn + self.imgs.count - 1) / kItemsColumn);
    if (self.imgChangeBlock != nil) {
        self.imgChangeBlock(self.imgs, self.imgViewHeight);
    }
}

- (CGSize)imgItemSize
{
    CGFloat itemWH = [self itemsWHeight];
    CGSize size = CGSizeMake(itemWH, itemWH);
    HTLog(@"item size = %@",NSStringFromCGSize(size));
    return size;
}

- (NSMutableArray*)imgsWithAssets:(NSArray*)assets
{
    NSMutableArray *imgsArra = [NSMutableArray array];
    for (LGPhotoAssets *photoAsset in assets){
        [imgsArra addObject:photoAsset.compressionImage];
    }
    return imgsArra;
}

//确认
- (void)showPhotoLibraryView{
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:LGShowImageTypeImagePicker];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;   // 最多能选9张图片
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self.currentController];
}

#pragma mark - LGPhotoPickerViewControllerDelegate
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original
{
    HTLog(@"pickerViewControllerDoneAsstes");
    NSMutableArray *selectedImgsArra = [self imgsWithAssets:assets];
//    UIImage *addImg = [self.imgs lastObject];
//    [self.imgs removeLastObject];
    [selectedImgsArra addObjectsFromArray:self.imgs];
    self.imgs = selectedImgsArra;
    [self updateImgsCount];
}


#pragma mark - collectionView  data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return self.imgs.count;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgItemCell *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:ImgItemCellID forIndexPath:indexPath];
    UIImage *img = [self.imgs objectAtIndex:indexPath.item];
//    collectCell.img = img;
    ItemType itemType = [self itemTypeForIndexPath:indexPath];
    [collectCell updateImg:img withType:itemType];
    __block typeof(self) blockSelf = self;
    collectCell.delImgBlock = ^{
        [blockSelf.imgs removeObjectAtIndex:indexPath.item];
        [blockSelf updateImgsCount];
    };
    return collectCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemType itemType = [self itemTypeForIndexPath:indexPath];
    if (itemType == ItemTypeAdd){
        [self showPhotoLibraryView];
    }
}

#pragma mark - UIcollectionView flow Layout  delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self imgItemSize];
}


@end
