//
//  ViewController.m
//  无限滚动
//
//  Created by MS on 15/8/26.
//  Copyright (c) 2015年 郑武. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "CellModel.h"
#import "Cell.h"

#define HMCelldentifier @"news"

#define HMMaxSections 100

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectinView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *newses;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (NSArray *)newses
{
    if (_newses == nil) {
     
        self.newses = [CellModel objectArrayWithFilename:@"newses.plist"];

        self.pageControl.numberOfPages = self.newses.count;
        
    }
    
    return _newses;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //注册cell
    [self.collectinView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:HMCelldentifier];
    
    //默认显示最中间的那组
    [self.collectinView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:HMMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    
    //添加定时器
    [self addTimer];
    
    
    
    
    
}

//添加定时器
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;

}

//移除定时器
- (void)removeTimer
{
    //停止定时器
    [self.timer invalidate];
    
    self.timer = nil;

}

//下一页
- (void)nextPage
{
    //马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];

    //计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    
    NSInteger nextSection = currentIndexPathReset.section;
    
    if (nextItem == self.newses.count) {
        
        nextItem = 0;
        
        nextSection++;
        
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //通过动画滚动到下一个位置
    [self.collectinView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    

}

- (NSIndexPath *)resetIndexPath
{

    //当前正在显示的位置
    NSIndexPath *currentIndexPath = [[self.collectinView indexPathsForVisibleItems] lastObject];
    
    //马上显示会最中间那组数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:HMMaxSections/2];
    
    [self.collectinView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    return currentIndexPathReset;
    
}

#pragma  mark   UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return HMMaxSections;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{


    return self.newses.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HMCelldentifier forIndexPath:indexPath];
    
    cell.modle = self.newses[indexPath.item];
    

    return cell;
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return collectionView.frame.size;
}

#pragma mark  UICollectionViewDelegate

//当用户即将开始拖拽的时候就调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];

}

//当用户停止拖拽的时候就调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    [self addTimer];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5) % self.newses.count;
    
    self.pageControl.currentPage = page;
    


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
