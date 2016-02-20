//
//  WSGComposeViewController.h
//  weibo
//
//  Created by user on 16/2/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,WSGComposeType) {
    WSGComposeTypeStatus, //发微博
    WSGComposeTypeRetweet, //转发
    WSGComposeTypeComment, //评论
};

@interface WSGComposeViewController : UIViewController

@property (nonatomic,assign) WSGComposeType composeType;

@end
