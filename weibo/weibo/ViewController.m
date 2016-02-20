//
//  ViewController.m
//  weibo
//
//  Created by user on 16/2/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"
#import "WSGComposeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didClickLeftBarButtonItem)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)didClickLeftBarButtonItem
{
    WSGComposeViewController *composeVC = [[WSGComposeViewController alloc] init];
    
    [self.navigationController pushViewController:composeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
