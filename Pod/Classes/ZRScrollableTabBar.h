//
//  ZRScrollableTabBar.h
//  ZRScrollableTabBar
//
//  Created by Abdullah Md. Zubair on 2/2/15.
//  Copyright (c) 2015 Abdullah Md. Zubair. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRScrollableTabBarDelegate;

@interface ZRScrollableTabBar : UIView <UIScrollViewDelegate, UITabBarDelegate> {
    __unsafe_unretained id <ZRScrollableTabBarDelegate> scrollableTabBarDelegate;
    NSMutableArray *tabBars;
    UIButton *nextButton;
    UIButton *previousButton;
    __strong UIScrollView *tabScrollView;
}

@property (nonatomic, assign) __unsafe_unretained id scrollableTabBarDelegate;
@property (nonatomic, retain) NSMutableArray *tabBars;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *previousButton;
@property (nonatomic, strong) __strong UIScrollView *tabScrollView;

@property (nonatomic, strong) UIColor* bgSelectedColor;
@property (nonatomic, strong) UIColor* unselectedItemTintColor;
@property (nonatomic, strong) UIColor* tintColor;
@property (nonatomic, strong) UIColor* selectedTintColor;

@property (nonatomic, strong) UIImage* nextButtonImage;
@property (nonatomic, strong) UIImage* previousButtonImage;

- (id)initWithItems:(NSArray *)items;
- (id)initWithItems:(NSArray *)items maxPerTab: (NSInteger) perTab;
- (id)initWithItems:(NSArray *)items maxPerTab: (NSInteger) perTab defaultTag: (NSInteger) tag;
- (void)setItems:(NSArray *)items animated:(BOOL)animated;
- (int)currentTabBarTag;
- (int)selectedItemTag;
- (BOOL)scrollToTabBarWithTag:(int)tag animated:(BOOL)animated;
- (BOOL)selectItemWithTag:(int)tag;
- (void) updateControlButtons;

- (UITabBarItem*) itemWithTag: (int) tag;

-(void)goToNextTabBar;
-(void)goToPreviousTabBar;

- (void) setSelected: (UITabBarItem*) item in: (UITabBar*) tabBar;

@end

@protocol ZRScrollableTabBarDelegate <NSObject>
- (BOOL)scrollableTabBar:(ZRScrollableTabBar *)tabBar shouldSelectItemWithTag:(int)tag;
- (void)scrollableTabBar:(ZRScrollableTabBar *)tabBar didSelectItemWithTag:(int)tag;
@end
