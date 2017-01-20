//
//  DetailViewController.m
//  TranistionAnimate
//
//  Created by peng_qitao on 16/10/11.
//  Copyright © 2016年 peng_qitao. All rights reserved.
//

#import "DetailViewController.h"
#import "popTransition.h"
#import "MJRefresh.h"

#define LC_APP_WINDOW ([UIApplication sharedApplication].delegate.window) //App的Window
#define LC_IMAGENAMED(imageName)  [UIImage imageNamed:imageName]  //图片快捷方式

@interface DetailViewController ()<UINavigationControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong,nonatomic) popTransition *popTransition;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.delegate = self;    
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.popTransition = [[popTransition alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.navigationController.delegate = self;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [(MJRefreshBackStateFooter *)self.scrollView.mj_footer setTitle:@"上拉关闭当前页" forState:MJRefreshStateIdle];
    [(MJRefreshBackStateFooter *)self.scrollView.mj_footer setTitle:@"释放关闭当前页" forState:MJRefreshStatePulling];
    [(MJRefreshBackStateFooter *)self.scrollView.mj_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    
    [self setNavBarBackButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarBackButton
{
    UIImage *image = LC_IMAGENAMED(@"common_icon_backarrow");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLeftNaviItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)onLeftNaviItemClick:(UIButton *)btn
{
    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(nullable id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.popTransition;
    }
    return nil;
}
@end
