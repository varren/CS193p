//
//  MenuDataTVC.m
//  SPoT
//
//  Created by mmh on 13/11/2013.
//  Copyright (c) 2013 mmh. All rights reserved.
//

#import "SplitViewDelegateTVC.h"

@interface SplitViewDelegateTVC ()<UISplitViewControllerDelegate>

@end

@implementation SplitViewDelegateTVC
#pragma mark - UISplitViewControllerDelegate


-(void)awakeFromNib{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    
    barButtonItem.title = @"Show Menu";
    id detailsSplitViewController = [self.splitViewController.viewControllers lastObject];
    
    if([detailsSplitViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailsSplitViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:barButtonItem];
    else
        NSLog(@"HIDE %@, cant preform selector", detailsSplitViewController);
    
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    id detailsSplitViewController = [self.splitViewController.viewControllers lastObject];
    
    if([detailsSplitViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)])
        [detailsSplitViewController performSelector:@selector(setSplitViewBarButtonItem:) withObject:nil];
    else{
        NSLog(@"SHOW %@, cant preform selector", detailsSplitViewController);
    }
}

@end
