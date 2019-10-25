//
//  ZRViewController.m
//  ZRScrollableTabBar
//
//  Created by raihan on 02/03/2015.
//  Copyright (c) 2014 raihan. All rights reserved.
//

#import "ZRViewController.h"
#import "ZRScrollableTabBar.h"

@interface ZRViewController ()<ZRScrollableTabBarDelegate>

@end

@implementation ZRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initScrollableTabbar];
}

-(void)initScrollableTabbar
{
    // Tab bar
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    item1.selectedImage = [item1.image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    item1.image = [item1.image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:4];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:5];
    UITabBarItem *item6 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:6];
    UITabBarItem *item7 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:7];
    UITabBarItem *item8 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:8];
    UITabBarItem *item9 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:9];
    
    ZRScrollableTabBar *tabBar = [[ZRScrollableTabBar alloc] initWithItems:[NSArray arrayWithObjects: item1, item2, item3, item4, item5, item6, nil]];
    tabBar.scrollableTabBarDelegate = self;
    tabBar.backgroundColor = [UIColor colorWithRed:0.10 green:0.56 blue:0.89 alpha:1.0];//[UIColor colorWithCSS: @"1A8FE3"];
    tabBar.bgSelectedColor = [UIColor colorWithRed:0.29 green:0.67 blue:0.95 alpha:1.0];//[UIColor colorWithCSS: @"49ABF1"];
    tabBar.tintColor = [UIColor whiteColor];
    tabBar.unselectedItemTintColor = [UIColor redColor];
    
    
    [self.view addSubview:tabBar];
}

- (void)scrollableTabBar:(ZRScrollableTabBar *)tabBar didSelectItemWithTag:(int)tag
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
