//
//  JY_ChatBar.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBar.h"
#import "JY_ChatFaceView.h"
#import "JY_ChatMoreView.h"
#import "PressButton.h"
#import "NSString+JYExtensions.h"

NSString* const kJYBatchDeleteTextPrefix = @"kJYBatchDeleteTextPrefix";
NSString* const kJYBatchDeleteTextSuffix = @"kJYBatchDeleteTextSuffix";

@interface JY_ChatBar ()<UITextViewDelegate, UINavigationControllerDelegate, JY_ChatMoreViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView* inputBarBackgroundView;   /** 输入栏目背景视图*/
@property (nonatomic, strong) UIButton* voiceButton; /**< 切换录音模式按钮*/
@property (strong, nonatomic) PressButton *voiceRecordButton; /**< 录音按钮 */

@property (strong, nonatomic) UIButton *faceButton; /**< 表情按钮 */
@property (strong, nonatomic) UIButton *moreButton; /**< 更多按钮 */
@property (strong, nonatomic) JY_ChatFaceView *faceView; /**< 当前活跃的底部view,用来指向faceView */
@property (strong, nonatomic) JY_ChatMoreView *moreView; /**< 当前活跃的底部view,用来指向moreView */

@property (nonatomic, copy) UIImagePickerController *pickerController;
@property (nonatomic, copy) void (^sendCustomMessageHandler)(id object, NSError *error);

@property (assign, nonatomic) CGSize keyboardSize;

@property (strong, nonatomic) UITextView* textView;
@property (assign, nonatomic) CGFloat oldTextViewHeight;
@property (nonatomic, assign, getter=shouldAllowTextViewContentOffset) BOOL allowTextViewContentOffset;
@property (nonatomic, assign, getter=isClosed) BOOL close;

@end

@implementation JY_ChatBar

#pragma mark - life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.close = NO;
    self.oldTextViewHeight = kJYChatBarTextViewFrameMinHeight;
    self.allowTextViewContentOffset = YES;
    [self addSubview:self.inputBarBackgroundView];
    
    [self.inputBarBackgroundView addSubview:self.voiceButton];
    [self.inputBarBackgroundView addSubview:self.moreButton];
    [self.inputBarBackgroundView addSubview:self.faceButton];
    [self.inputBarBackgroundView addSubview:self.textView];
    [self.inputBarBackgroundView addSubview:self.voiceRecordButton];
    
    UIImageView* topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    [self.inputBarBackgroundView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(.5f);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    [self setupConstraints];
}

- (void)setupConstraints{
    CGFloat offset = 5;
    [self.inputBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.bottom.equalTo(0).priorityLow();
    }];
    
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBarBackgroundView).offset(offset);
        make.bottom.equalTo(self.inputBarBackgroundView).offset(-kChatBarBottomOffset);
        make.width.equalTo(self.voiceButton.mas_height);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBarBackgroundView).offset(-offset);
        make.bottom.equalTo(self.inputBarBackgroundView).offset(-kChatBarBottomOffset);
        make.width.equalTo(self.moreButton.mas_height);
    }];
    
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).offset(-offset);
        make.bottom.equalTo(self.inputBarBackgroundView).offset(-kChatBarBottomOffset);
        make.width.equalTo(self.faceButton.mas_height);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).offset(offset);
        make.right.equalTo(self.faceButton.mas_left).offset(-offset);
        make.top.equalTo(self.inputBarBackgroundView).offset(kChatBarTextViewBottomOffset);
        make.bottom.equalTo(self.inputBarBackgroundView).offset(-kChatBarTextViewBottomOffset);
        make.height.greaterThanOrEqualTo(kJYChatBarTextViewFrameMinHeight);
    }];
    
    CGFloat voiceRecordButtoInsets = -5.f;
    [self.voiceRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView).insets(UIEdgeInsetsMake(voiceRecordButtoInsets, voiceRecordButtoInsets, voiceRecordButtoInsets, voiceRecordButtoInsets));
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 
#pragma mark - Setter Method

- (void)setCachedText:(NSString *)cachedText {
    _cachedText = [cachedText copy];
    if ([_cachedText isEqualToString:@""]) {
        self.allowTextViewContentOffset = YES;
        return;
    }
    if ([_cachedText jy_isSpace]) {
        _cachedText = @"";
        return;
    }
}

- (void)setDelegate:(id<JY_ChatBarDelegate>)delegate{
    _delegate = delegate;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location == [textView.text length]) {
        self.allowTextViewContentOffset = YES;
    } else {
        self.allowTextViewContentOffset = NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage:textView.text];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewDidChange:textView shouldCacheText:YES];
}

#pragma mark -
#pragma mark - Private Methods


- (void)updateChatBarConstraintsIfNeededShouldCacheText:(BOOL)shouldCacheText {
    [self textViewDidChange:self.textView shouldCacheText:shouldCacheText];
}

- (void)updateChatBarKeyBoardConstraintsWithDuration:(CGFloat)duration {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-self.keyboardSize.height);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:shouldScrollToBottom:)]) {
        [self.delegate chatBarFrameDidChange:self shouldScrollToBottom:YES];
    }
}

#pragma mark - 核心方法

/**
 * 只要文本修改了就会调用，特殊情况，也会调用：刚刚进入对话追加草稿、键盘类型切换、添加表情信息
 */
- (void)textViewDidChange:(UITextView *)textView shouldCacheText:(BOOL)shouldCacheText {
    if (shouldCacheText) {
        self.cachedText = self.textView.text;
    }
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    textView.scrollEnabled = (textSize.height > kJYChatBarTextViewFrameMinHeight);
    
    CGFloat newTextViewHeight = MAX(kJYChatBarTextViewFrameMinHeight, MIN(kJYChatBarTextViewFrameMaxHeight, textSize.height));
    BOOL textViewHeightChanged = (self.oldTextViewHeight != newTextViewHeight);
    if (textViewHeightChanged) {
        
        self.oldTextViewHeight = newTextViewHeight;
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = newTextViewHeight;
            make.height.equalTo(height);
        }];
        
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        } completion:nil];
        
        [self chatBarFrameDidChangeShouldScrollToBottom:YES];
    }
    if (textView.scrollEnabled && self.allowTextViewContentOffset) {
        if (newTextViewHeight == kJYChatBarTextViewFrameMaxHeight) {
            [textView setContentOffset:CGPointMake(0, textView.contentSize.height - newTextViewHeight) animated:YES];
        } else {
            [textView setContentOffset:CGPointZero animated:YES];
        }
    }
}

#pragma mark - JY_ChatMoreViewDelegate

- (void)chatMoreView:(JY_ChatMoreView *)moreView clickIndex:(NSUInteger)index {
    if (1 == index) {
        //相册
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if(2 == index){
        //拍照
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self.textView resignFirstResponder];
    self.textView.inputView = nil;
    self.moreButton.selected = NO;
    
    [self.controllerRef presentViewController:self.pickerController animated:YES completion:nil];
}

- (void (^)(id, NSError *))sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    
    __weak __typeof(self)weakSelf = self;
    void (^sendCustomMessageHandler)(id, NSError *) = ^(id object, NSError *error) {
        [weakSelf.controllerRef dismissViewControllerAnimated:YES completion:nil];
        NSString *image = (NSString *)object;
        if (object) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBar:sendPictures:)]) {
                [weakSelf.delegate chatBar:weakSelf sendPictures:@[image]];
            }
        }
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}


#pragma mark----将图片保存到沙盒
 
- (void)saveImageToSandbox:(UIImage *)image andImageNage:(NSString *)imageName andResultBlock:(resultBlock)block
{
    //高保真压缩图片，此方法可将图片压缩，但是图片质量基本不变，第二个参数为质量参数
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    //将图片写入文件
    NSString *filePath=[NSHomeDirectory() stringByAppendingString:imageName];
    //是否保存成功
    BOOL result=[imageData writeToFile:filePath atomically:YES];
    //保存成功传值到blcok中
    if (result) {
        block(result);
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    
    NSString* fileName = [NSString stringWithFormat:@"/Library/%ld.jpg", (NSInteger)interval];
    
    [self saveImageToSandbox:image andImageNage:fileName andResultBlock:^(BOOL success) {
        if (success) {
            NSString* imageUrl = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
            
            !self.sendCustomMessageHandler ? : self.sendCustomMessageHandler(imageUrl, nil);
        }else {
            !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(nil, nil);
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSInteger code = 0;
    NSString *errorReasonText = @"cancel image picker without result";
    NSDictionary *errorInfo = @{
                                @"code":@(code),
                                NSLocalizedDescriptionKey : errorReasonText,
                                };
    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:code
                                     userInfo:errorInfo];
    !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(nil, error);
}

#pragma mark - Private Methods

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CGFloat height = SCREEN_HEIGHT - [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGSize  kSize = CGSizeMake(SCREEN_WIDTH, height);
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardSize = kSize;
    
    [self updateChatBarKeyBoardConstraintsWithDuration:duration];
}

- (void)faceAction:(UIButton *)sender
{
    [self showVoiceView:NO];
    _moreButton.selected = NO;
    
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.textView.inputView = self.faceView;
        if ([self.textView isFirstResponder]) {
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }else
    {
        self.textView.inputView = nil;
        if ([self.textView isFirstResponder]) {
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)moreAction:(UIButton *)sender
{
    [self showVoiceView:NO];
    _faceButton.selected = NO;
    
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.textView.inputView = self.moreView;
        if ([self.textView isFirstResponder]) {
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }else
    {
        self.textView.inputView = nil;
        if ([self.textView isFirstResponder]) {
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)voiceAction:(UIButton *)sender
{
    _faceButton.selected = NO;
    _moreButton.selected = NO;
    sender.selected = !sender.selected;
    
    [self showVoiceView:sender.isSelected];
    
    if (sender.selected) {
        self.cachedText = self.textView.text;
        self.textView.text = nil;
        [self.textView resignFirstResponder];
        
        [self textViewDidChange:self.textView shouldCacheText:NO];
        
    } else {
        self.textView.inputView = nil;
        if ([self.textView isFirstResponder]) {
            [self.textView reloadInputViews];
        }else{
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)showVoiceView:(BOOL)show {
    self.voiceButton.selected = show;
    self.voiceRecordButton.hidden = !show;
    self.textView.hidden = !self.voiceRecordButton.hidden;
}

/**
 *  发送普通的文本信息,通知代理
 *
 *  @param text 发送的文本信息
 */
- (void)sendTextMessage:(NSString *)text{
    if (!text || text.length == 0 || [text jy_isSpace]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
        [self.delegate chatBar:self sendMessage:text];
    }
    self.textView.text = @"";
    self.cachedText = @"";
    [self textViewDidChange:self.textView shouldCacheText:NO];
}

/**
 *  通知代理发送语音信息
 *
 *  @param voiceData 发送的语音信息data
 *  @param seconds   语音时长
 */
- (void)sendVoiceMessage:(NSString *)voiceFileName seconds:(NSString *)seconds {
    if ((seconds > 0) && self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendVoice:seconds:)]) {
        [self.delegate chatBar:self sendVoice:voiceFileName seconds:seconds];
    }
}

/**
 *  通知代理发送图片信息
 *
 *  @param image 发送的图片
 */
- (void)sendImageMessage:(UIImage *)image {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendPictures:)]) {
        [self.delegate chatBar:self sendPictures:@[image]];
    }
}

- (void)chatBarFrameDidChangeShouldScrollToBottom:(BOOL)shouldScrollToBottom {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:shouldScrollToBottom:)]) {
        [self.delegate chatBarFrameDidChange:self shouldScrollToBottom:shouldScrollToBottom];
    }
}

#pragma mark - Getters

- (UIView *)inputBarBackgroundView{
    if (!_inputBarBackgroundView) {
        UIView* inputBarBackgroundView = [[UIView alloc] init];
        _inputBarBackgroundView = inputBarBackgroundView;
    }
    return _inputBarBackgroundView;
}

- (UIImagePickerController *)pickerController {
    if (_pickerController) {
        return _pickerController;
    }
    _pickerController = [[UIImagePickerController alloc] init];
//    _pickerController.allowsEditing = YES;
    _pickerController.delegate = self;
    return _pickerController;
}

- (JY_ChatFaceView *)faceView {
    if (!_faceView) {
        JY_ChatFaceView *faceView = [[JY_ChatFaceView alloc] init];
        faceView.inputDelegate = self.textView;
        
        __weak __typeof(self)weakSelf = self;
        faceView.faceViewSendBlock = ^(){
            [weakSelf sendTextMessage:weakSelf.textView.text];
        };
        
        faceView.backgroundColor = self.backgroundColor;
        _faceView = faceView;
    }
    return _faceView;
}

- (JY_ChatMoreView *)moreView {
    if (!_moreView) {
        JY_ChatMoreView *moreView = [[JY_ChatMoreView alloc] init];
        moreView.delegate = self;
        _moreView = moreView;
    }
    return _moreView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.backgroundColor = RGBCOLOR(255, 255, 255, 1);
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
        _textView.scrollsToTop = NO;
    }
    return _textView;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
    }
    return _voiceButton;
}

- (UIButton *)voiceRecordButton {
    if (!_voiceRecordButton) {
        _voiceRecordButton = [[PressButton alloc] init];
        _voiceRecordButton.hidden = YES;
        _voiceRecordButton.frame = self.textView.bounds;
        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_voiceRecordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
        UIImage *voiceRecordButtonNormalBackgroundImage = [[UIImage imageNamed:@"VoiceBtn_Black"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        UIImage *voiceRecordButtonHighlightedBackgroundImage = [[UIImage imageNamed:@"VoiceBtn_BlackHL"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        [_voiceRecordButton setBackgroundImage:voiceRecordButtonNormalBackgroundImage forState:UIControlStateNormal];
        [_voiceRecordButton setBackgroundImage:voiceRecordButtonHighlightedBackgroundImage forState:UIControlStateHighlighted];
        _voiceRecordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        __weak typeof(self) weakSelf = self;
        _voiceRecordButton.sendVoice = ^(NSString *text) {
            NSArray* arr = [text componentsSeparatedByString:@"+"];
            [weakSelf sendVoiceMessage:text seconds:arr[0]];
        };
    }
    return _voiceRecordButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton sizeToFit];
    }
    return _faceButton;
}

- (void) dismiss {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    self.faceButton.selected = self.moreButton.selected = self.voiceButton.selected = NO;
    self.textView.inputView = nil;
}

@end
