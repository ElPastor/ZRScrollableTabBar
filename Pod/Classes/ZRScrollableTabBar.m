//
//  ZRScrollableTabBar.m
//  ZRScrollableTabBar
//
//  Created by Abdullah Md. Zubair on 2/2/15.
//  Copyright (c) 2015 Abdullah Md. Zubair. All rights reserved.
//

#import "ZRScrollableTabBar.h"

#define ButtonNoPerTab 5.0
#define TabHeight 49.0
#define ControlButtonWidth 32.0
#define TabWidth [[UIScreen mainScreen] bounds].size.width-ControlButtonWidth*2

@interface ZRScrollableTabBar ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic, assign) CGFloat maxPerBar;

@end

@implementation ZRScrollableTabBar

@synthesize scrollableTabBarDelegate;
@synthesize tabBars;
@synthesize nextButton;
@synthesize previousButton;
@synthesize tabScrollView;

- (id)initWithItems:(NSArray *)items {
    return [self initWithItems: items maxPerTab: ButtonNoPerTab];
}

- (id)initWithItems:(NSArray *)items maxPerTab: (NSInteger) perTab {
    return [self initWithItems: items maxPerTab: ButtonNoPerTab defaultTag: 0];
}

- (id)initWithItems:(NSArray *)items maxPerTab: (NSInteger) perTab defaultTag: (NSInteger) tag {
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self = [super initWithFrame:CGRectMake(0.0, screenHeight-TabHeight, screenWidth, TabHeight)];
    if (self)
    {
        tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(ControlButtonWidth, 0.0, TabWidth, TabHeight)];
        self.maxPerBar = perTab;
        previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousButton setFrame:CGRectMake(2, 14, ControlButtonWidth, 21)];
        [previousButton setBackgroundColor: UIColor.clearColor];
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setFrame:CGRectMake(TabWidth + ControlButtonWidth, 14, ControlButtonWidth, 21)];
        [nextButton setBackgroundColor: UIColor.clearColor];
        [nextButton addTarget:self action:@selector(goToNextTabBar) forControlEvents:UIControlEventTouchUpInside];
        [previousButton addTarget:self action:@selector(goToPreviousTabBar) forControlEvents:UIControlEventTouchUpInside];
        [previousButton setImage:nil forState:UIControlStateNormal];
        [nextButton setImage:nil forState:UIControlStateNormal];

        [self addSubview:nextButton];
        [self addSubview:previousButton];
        tabScrollView.pagingEnabled = YES;
        tabScrollView.delegate = self;
        tabScrollView.showsHorizontalScrollIndicator = NO;
        tabScrollView.bounces = NO;
        
        self.tabBars = [[NSMutableArray alloc] init];
        
        float x = 0.0;
        
        for (double d = 0; d < ceil(items.count / self.maxPerBar); d ++)
        {
            UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(x, 0.0, TabWidth, TabHeight)];
            tabBar.delegate = self;
            tabBar.backgroundImage = [UIImage new];
            tabBar.shadowImage = [UIImage new];
            int len = 0;
            
            for (int i = d * self.maxPerBar; i < d * self.maxPerBar + self.maxPerBar; i ++)
                if (i < items.count)
                    len ++;
            
            tabBar.items = [items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(d * self.maxPerBar, len)]];
            
            [self.tabScrollView addSubview:tabBar];
            
            [self.tabBars addObject:tabBar];
            [self addSubview:tabScrollView];
            
            x += TabWidth;
        }
        [self selectItemWithTag: (int)tag];
        [self.tabScrollView setContentSize:CGSizeMake(x, TabHeight)];
        [self scrollToTabBarWithTag: (int)tag animated: NO];

    }
    [self updateControlButtons];

    return self;
}

- (void) didMoveToWindow {
    [super didMoveToWindow];
    
    if (@available(iOS 11.0, *)) {
        CGFloat offset = UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.bottom;
        CGRect frame = self.frame;
        frame.origin.y -= offset;
        frame.size.height += offset;
        self.frame = frame;

        for (UITabBar *tabBar in self.tabBars) {
            CGRect frame = tabBar.frame;
            frame.size.height = self.tabScrollView.frame.size.height;
            tabBar.frame = frame;
        }
    }
}

-(void)goToNextTabBar
{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((tabScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollToPage:page+1 animation:YES];
}

-(void)goToPreviousTabBar
{
    CGFloat pageWidth = self.frame.size.width;
    int page = floor((tabScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self scrollToPage:page-1 animation:YES];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated {
    for (UITabBar *tabBar in self.tabBars) {
        int len = 0;
        
        for (int i = [self.tabBars indexOfObject:tabBar] * self.maxPerBar; i < [self.tabBars indexOfObject:tabBar] * self.maxPerBar + self.maxPerBar; i ++)
            if (i < items.count)
                len ++;
        
        [tabBar setItems:[items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.tabBars indexOfObject:tabBar] * self.maxPerBar, len)]] animated:animated];
    }
    
    tabScrollView.contentSize = CGSizeMake(ceil(items.count / self.maxPerBar) * screenWidth, TabHeight);
}

- (int)currentTabBarTag {
    return tabScrollView.contentOffset.x / screenWidth;
}

- (int)selectedItemTag {
    for (UITabBar *tabBar in self.tabBars)
        if (tabBar.selectedItem != nil)
            return (int)tabBar.selectedItem.tag;
    
    // No item selected
    return 0;
}

- (BOOL)scrollToTabBarWithTag:(int)tag animated:(BOOL)animated {
    
    for (UITabBar *tabBar in self.tabBars)
        for (UITabBarItem *item in tabBar.items)
            if (item.tag == tag) {
                tabBar.selectedItem = item;
                
                [tabScrollView scrollRectToVisible:tabBar.frame animated:animated];
                [self tabBar:tabBar didSelectItem:item];
                
                return YES;
            }
    
    return NO;
    
}

- (BOOL)selectItemWithTag:(int)tag {
    for (UITabBar *tabBar in self.tabBars)
        for (UITabBarItem *item in tabBar.items)
            if (item.tag == tag) {
                tabBar.selectedItem = item;
                
                [self tabBar:tabBar didSelectItem:item];
                
                return YES;
            }
    
    return NO;
}

- (UITabBarItem*) itemWithTag: (int) tag
{
    for (UITabBar *tabBar in self.tabBars)
        for (UITabBarItem *item in tabBar.items)
            if (item.tag == tag) {
                return item;
            }
    
    return nil;
}

- (void) updateControlButtons
{
    CGFloat pageWidth = tabScrollView.frame.size.width;
    double maxPage = ceil(tabScrollView.contentSize.width / screenWidth) - 1;
    int page = floor((tabScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.tabBars.count == 1)
    {
        [previousButton setImage:nil forState:UIControlStateNormal];
        [nextButton setImage: nil forState:UIControlStateNormal];
    }
    else if (page == 0)
    {
        [previousButton setImage:nil forState:UIControlStateNormal];
        [nextButton setImage:self.nextButtonImage?:[UIImage imageNamed:@"arrrow_right.png"] forState:UIControlStateNormal];
    }
    else if (page == maxPage)
    {
        [previousButton setImage:self.previousButtonImage?:[UIImage imageNamed:@"arrrow_left.png"] forState:UIControlStateNormal];
        [nextButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [previousButton setImage:self.previousButtonImage?:[UIImage imageNamed:@"arrrow_left.png"] forState:UIControlStateNormal];
        [nextButton setImage:self.nextButtonImage?:[UIImage imageNamed:@"arrrow_right.png"] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateControlButtons];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

-(void)scrollToPage:(int)page animation:(BOOL)animated
{
    CGRect frame = self.tabScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [tabScrollView scrollRectToVisible:frame animated:animated];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)tabBar:(UITabBar *)cTabBar didSelectItem:(UITabBarItem *)item {
    if ([self.scrollableTabBarDelegate respondsToSelector: @selector(scrollableTabBar:shouldSelectItemWithTag:)]) {
        if (![self.scrollableTabBarDelegate scrollableTabBar: self shouldSelectItemWithTag: (int)item.tag]) {
            return;
        }
    }
    // Act like a single tab bar
    for (UITabBar *tabBar in self.tabBars)
        if (tabBar != cTabBar)
            tabBar.selectedItem = nil;
 
    [self setSelected: item in: cTabBar];
    
    [self.scrollableTabBarDelegate scrollableTabBar:self didSelectItemWithTag:(int)item.tag];
}

- (void) setSelected: (UITabBarItem*) item in: (UITabBar*) tabBar
{
    [self clearSelection];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < tabBar.items.count; i++) {
            UITabBarItem * ii = tabBar.items[i];
            if (item == ii) {
                UIView* sv = tabBar.subviews[i+1];
                sv.backgroundColor = self.bgSelectedColor;
            }
        }
    });
}

- (void) clearSelection
{
    for (UITabBar *tabBar in tabBars) {
        for (UIView* view in tabBar.subviews) {
            view.backgroundColor = self.backgroundColor;
        }
    }
}

- (void) setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    for (UITabBar *tabBar in tabBars) {
        tabBar.tintColor = tintColor;
    }
}

- (void) setUnselectedItemTintColor:(UIColor *)unselectedItemTintColor
{
    _unselectedItemTintColor = unselectedItemTintColor;
    for (UITabBar *tabBar in tabBars) {
        tabBar.unselectedItemTintColor = unselectedItemTintColor;
    }
}

- (void)dealloc {
}

@end

@interface UITabBarController()
@end
