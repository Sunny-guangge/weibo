//
//  WSGComposeViewController.m
//  weibo
//
//  Created by user on 16/2/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "WSGComposeViewController.h"
#import "YYKit.h"

@interface WSGComposeViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UIView *textInputView;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UIView *toolBar;
@property (nonatomic,strong) UIView *toolBackView;
@property (nonatomic,strong) UIButton *toolBarPOIButton;
@property (nonatomic,strong) UIButton *toolBarGroupButton;
@property (nonatomic,strong) UIButton *toolBarPictureButton;
@property (nonatomic,strong) UIButton *toolBarAtButton;
@property (nonatomic,strong) UIButton *toolBarTopicButton;
@property (nonatomic,strong) UIButton *toolBarEmotionButton;
@property (nonatomic,strong) UIButton *toolBarMoreButton;

@property (nonatomic,assign) BOOL isEmotion;

@end

@implementation WSGComposeViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)keyboardWillAppearance:(NSNotification *)noti
{
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    [UIView animateWithDuration:duration animations:^{
        
        _toolBar.bottom = frame.origin.y;
        _textView.contentInset = UIEdgeInsetsMake(64, 0, 81 + frame.size.height, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:duration animations:^{
        
        _toolBar.bottom = frame.origin.y;
        _textView.contentInset = UIEdgeInsetsMake(64, 0, 81, 0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initNavBar];
     
    [self initUITextView];
    
    [self initButtonTool];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppearance:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_textView becomeFirstResponder];
}

#pragma mark - UINavigationBarItem
- (void)initNavBar
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancleButton)];
    
    [leftBarButton setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                            NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    switch (_composeType) {
        case WSGComposeTypeComment:
            
            self.navigationItem.title = @"评论";
            
            break;
            
        case WSGComposeTypeRetweet:
            
            self.navigationItem.title = @"转发";
            
            break;
            
        case WSGComposeTypeStatus:
            
            self.navigationItem.title = @"发微博";
            
            break;
            
        default:
            break;
    }
}

- (void)didClickCancleButton
{
    [self.view endEditing:YES];
    
    [_textView resignFirstResponder];
}

#pragma mark - UITextView
- (void)initUITextView
{
    if (_textView) {
        return;
    }
    
    _textView = [[UITextView alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7) {
        
        _textView.top = -64;
        
    }
    
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _textView.contentInset = UIEdgeInsetsMake(64, 0, 81, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsEditingTextAttributes = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
//    _textView.inputView
    NSString *text = nil;
    
    switch (_composeType) {
        case WSGComposeTypeStatus:
            text = @"分享新鲜事...";
            break;
            
        case WSGComposeTypeRetweet:
            text = @"说说分享心得...";
            break;
            
        case WSGComposeTypeComment:
            text = @"发布评论...";
            break;
            
        default:
            break;
    }
    
    _textView.text = text;
    
    [self.view addSubview:_textView];
    
}

- (void)initButtonTool
{
    if (_toolBar) {
        return;
    }
    
    _toolBar = [UIView new];
    _toolBar.size = CGSizeMake(self.view.width, 81);
    _toolBar.backgroundColor = [UIColor whiteColor];
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _toolBackView = [UIView new];
    _toolBackView.backgroundColor = [UIColor whiteColor];
    _toolBackView.size = CGSizeMake(_toolBar.width, 46);
    _toolBackView.bottom = _toolBar.height;
    _toolBackView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolBar addSubview:_toolBackView];
    
    _toolBackView.height = 300;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.width = _toolBackView.width;
    lineView.height = 0.5;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_toolBackView addSubview:lineView];
    
    _toolBarPOIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolBarPOIButton.size = CGSizeMake(88, 26);
    _toolBarPOIButton.centerY = 35 / 2.0;
    _toolBarPOIButton.left = 5;
    _toolBarPOIButton.clipsToBounds = YES;
    _toolBarPOIButton.layer.cornerRadius = _toolBarPOIButton.height / 2;
    _toolBarPOIButton.layer.borderColor = [UIColor colorWithHexString:@"e4e4e4"].CGColor;
    _toolBarPOIButton.layer.borderWidth = 0.5;
    _toolBarPOIButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _toolBarPOIButton.adjustsImageWhenHighlighted = NO;
    [_toolBarPOIButton setTitle:@"显示位置" forState:UIControlStateNormal];
    [_toolBarPOIButton setTitleColor:[UIColor colorWithHexString:@"939393"] forState:UIControlStateNormal];
    [_toolBarPOIButton setImage:[UIImage imageNamed:@"compose_locatebutton_ready"] forState:UIControlStateNormal];
    [_toolBarPOIButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"]] forState:UIControlStateNormal];
    [_toolBarPOIButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e0e0e0"]] forState:UIControlStateHighlighted];
    [_toolBar addSubview:_toolBarPOIButton];
    
    
    _toolBarGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toolBarGroupButton.size = CGSizeMake(62, 26);
    _toolBarGroupButton.centerY = 35 / 2.0;
    _toolBarGroupButton.right = _toolBar.width - 5;
    _toolBarGroupButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _toolBarGroupButton.clipsToBounds = YES;
    _toolBarGroupButton.layer.cornerRadius = _toolBarGroupButton.height / 2;
    _toolBarGroupButton.layer.borderColor = [UIColor colorWithHexString:@"e4e4e4"].CGColor;
    _toolBarGroupButton.layer.borderWidth = 0.5;
    _toolBarGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _toolBarGroupButton.adjustsImageWhenHighlighted = NO;
    [_toolBarGroupButton setTitle:@"公开" forState:UIControlStateNormal];
    [_toolBarGroupButton setTitleColor:[UIColor colorWithHexString:@"527ead"] forState:UIControlStateNormal];
    [_toolBarGroupButton setImage:[UIImage imageNamed:@"compose_publicbutton"] forState:UIControlStateNormal];
    [_toolBarGroupButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"]] forState:UIControlStateNormal];
    [_toolBarGroupButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e0e0e0"]] forState:UIControlStateHighlighted];
    [_toolBar addSubview:_toolBarGroupButton];
    
    
    _toolBarPictureButton = [self _toolbarButtonWithImage:@"compose_toolbar_picture"
                                                highlight:@"compose_toolbar_picture_highlighted"];
    _toolBarAtButton = [self _toolbarButtonWithImage:@"compose_mentionbutton_background"
                                           highlight:@"compose_mentionbutton_background_highlighted"];
    _toolBarTopicButton = [self _toolbarButtonWithImage:@"compose_trendbutton_background"
                                              highlight:@"compose_trendbutton_background_highlighted"];
    _toolBarEmotionButton = [self _toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];
    _toolBarMoreButton = [self _toolbarButtonWithImage:@"message_add_background"
                                              highlight:@"message_add_background_highlighted"];
    
    CGFloat one = _toolBar.width / 5;
    _toolBarPictureButton.centerX = one * 0.5;
    _toolBarAtButton.centerX = one * 1.5;
    _toolBarTopicButton.centerX = one * 2.5;
    _toolBarEmotionButton.centerX = one * 3.5;
    _toolBarMoreButton.centerX = one * 4.5;
    
    
    
    _toolBar.bottom = self.view.height;
    [self.view addSubview:_toolBar];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBackView addSubview:button];
    return button;
}

- (void)_buttonClicked:(UIButton *)button
{
    if (button == _toolBarEmotionButton) {
        
        if (_textView.inputView) {
            
            _textView.inputView = nil;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            
            
        }else
        {
            
            UIView *view = [UIView new];
            view.frame = CGRectMake(0, 0, self.view.width, 216);
            _textView.inputView = view;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            
        }
        
        
    }
}

- (UIView *)textInputView
{
    if (_textInputView == nil) {
     
        _textInputView = [[UIView alloc] init];
        _textInputView.size = CGSizeMake(self.view.width, 216);
        
    }
    return _textView;
}

@end
