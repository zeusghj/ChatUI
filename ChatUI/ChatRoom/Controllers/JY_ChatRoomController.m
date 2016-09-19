//
//  JY_ChatRoomController.m
//  ChatUI
//
//  Created by 郭洪军 on 9/14/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import "JY_ChatRoomController.h"
#import "JY_ChatBar.h"
#import "JY_BaseChatRoomCell.h"
#import "JYModel.h"
#import "JY_ChatRoomManager.h"
#import "JY_UserHeader.h"
#import "DataManager.h"

static NSString* identifier = @"JY_BaseChatRoomCell";
static NSString* pic_reuse = @"pic_reuse";
static NSString* voi_reuse = @"voi_reuse";
static NSString* txt_reuse = @"txt_reuse";

@interface JY_ChatRoomController () <UITableViewDelegate, UITableViewDataSource, JY_ChatBarDelegate>
{
    //当弹出键盘时，内容会向上滚动，此时不能让键盘dissmiss
    BOOL _scrollViewState;
}

@property (nonatomic, strong) DMTarget* target;

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, weak) JY_ChatBar* chatBar;

@property (nonatomic, strong) NSMutableArray* msgArray;
@property (nonatomic, strong) NSArray* dataSourceArray;

@end

@implementation JY_ChatRoomController

- (instancetype)initWithTarget:(DMTarget *)target {
    if (self = [super init]) {
        self.target = target;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)createView {
    self.title = @"Chat";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.mas_greaterThanOrEqualTo(@(kJYChatBarMinHeight));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(self.chatBar.mas_top).priorityLow();
    }];
}

- (NSMutableArray *)msgArray
{
    if (!_msgArray) {
        _msgArray = [NSMutableArray new];
    }
    
    return _msgArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = RGBCOLOR(234, 234, 234, 1);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15.f)];
        [self.view addSubview:(_tableView = tableView)];;
    }
    return _tableView;
}

- (JY_ChatBar *)chatBar {
    if (!_chatBar) {
        JY_ChatBar* chatBar = [[JY_ChatBar alloc] init];
        chatBar.delegate = self;
        chatBar.controllerRef = self;
        [self.view addSubview:(_chatBar = chatBar)];
        [self.view bringSubviewToFront:chatBar];;
    }
    return _chatBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewToBottom
{
    _scrollViewState = YES;
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows == 0) {
        return;
    }
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
    _scrollViewState = NO;
}

#pragma mark - JY_ChatBarDelegate

- (void)chatBar:(JY_ChatBar *)chatBar sendMessage:(NSString *)message{
    
    JYModel* model = [self cofigMsgStrcutWithMsg:message];
    model.msg_Type = JY_ChatMessageTypeText;
    
    [self.msgArray addObject:model];
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rows  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self scrollViewToBottom];
    
}

- (void)chatBar:(JY_ChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSString *)seconds{
    
    JYModel* model = [self cofigMsgStrcutWithMsg:voiceFileName];
    model.msg_Type = JY_ChatRoomTypeVoice ;  //未听
    
    [self.msgArray addObject:model];
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rows  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self scrollViewToBottom];
}

- (void)chatBar:(JY_ChatBar *)chatBar sendPictures:(NSArray *)pictures {
    
    JYModel* model = [self cofigMsgStrcutWithMsg:pictures[0]];
    model.msg_Type = JY_ChatRoomTypePicture;
    
    [self.msgArray addObject:model];
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rows  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [self scrollViewToBottom];
    
}

- (void)chatBarFrameDidChange:(JY_ChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom {
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(0);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.tableView layoutIfNeeded];
    }];
    
    [self scrollViewToBottom];
}

#pragma mark - 组建消息结构体
- (JYModel *)cofigMsgStrcutWithMsg:(NSString *)msg
{
    static int i = 1;
    
    JYModel *model = [[JYModel alloc] init];
    
    if (i % 2 == 1) {
        model.msgSources = YES;
    }else
    {
        model.msgSources = NO;
    }
    
    i ++;
    
    model.userIcon = @"woman8.jpg";
    model.userName = @"一条小鱼";
    model.msg = msg;
    model.timestamp = @"18:43";
    model.showTimestamp = YES;
    return model;
}

#pragma mark - UITableViewDelegate  and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYModel* model = self.msgArray[indexPath.row];
    
    NSString* identifier = model.msg_Type == JY_ChatMessageTypeText ? txt_reuse :
    ((model.msg_Type == JY_ChatRoomTypePicture) ? pic_reuse : voi_reuse);
    
    
    JY_BaseChatRoomCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
    
    if (!cell) {
        cell = [[JY_BaseChatRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.msgModel = self.msgArray[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYModel *msg = self.msgArray[indexPath.row];
    if (msg.cacheMsgSize.height <= 0.f) {
        return [JY_ChatRoomManager calculateCellHeightWithMsg:msg];
    }
    return msg.cacheMsgSize.height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.chatBar dismiss];
}
@end
