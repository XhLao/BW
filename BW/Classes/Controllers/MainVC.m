//
//  MainVC.m
//  BW
//
//  Created by Xh.Lao on 2017/7/11.
//  Copyright © 2017年 Xh.Lao. All rights reserved.
//

#import "MainVC.h"
#import "BWButton.h"

@interface MainVC ()

@property (weak, nonatomic) IBOutlet UIView  *gameView;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *btnsArr;

@property (nonatomic, assign) NSInteger gameIndex;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger time;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"黑白配";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"再试一次"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleLeftBBI:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重玩"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleRightBBI:)];
    self.gameIndex = 3;
    self.step = 0;
    self.time = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadGameWithIndex:self.gameIndex];
    [self.timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (void)loadGameWithIndex:(NSInteger)index {
    for (NSMutableArray *arr in self.btnsArr) {
        for (BWButton *btn in arr) {
            [btn removeFromSuperview];
        }
    }
    [self.btnsArr removeAllObjects];
    self.step = 0;
    self.stepLabel.text = @"Step: 0";
    self.time = 0;
    
    for (int i = 0; i < index; i ++) {
        NSMutableArray *arr = [NSMutableArray new];
        [self.btnsArr addObject:arr];
    }
    
    CGFloat cuttingLines = index - 1;
    CGFloat btnWidth = (kScreenWidth - 30 - cuttingLines) / index;
    
    for (int i = 0; i < index; i ++) {
        for (int j = 0; j < index; j ++) {
            BWButton *btn = [BWButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(j * (btnWidth + 1), i * (btnWidth + 1), btnWidth, btnWidth);
            btn.backgroundColor = [UIColor whiteColor];
            btn.section = i;
            btn.row     = j;
            [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.gameView addSubview:btn];
            
            NSMutableArray *arr = self.btnsArr[i];
            [arr addObject:btn];
        }
    }
}

- (BOOL)checkWin {
    for (NSMutableArray *arr in self.btnsArr) {
        for (BWButton *btn in arr) {
            if ([btn.backgroundColor isEqual:[UIColor whiteColor]]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)showWinTip {
    __weak typeof(self) weakSelf = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"恭喜您，闯关成功!" message:@"点击进入下一关" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.gameIndex ++;
        [strongSelf loadGameWithIndex:strongSelf.gameIndex];
    }];
    [ac addAction:action];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Click
- (void)handleLeftBBI:(UIBarButtonItem *)bBI {
    __weak typeof(self) weakSelf = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定再试一次？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadGameWithIndex:strongSelf.gameIndex];
    }];
    [ac addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)handleRightBBI:(UIBarButtonItem *)bBI {
    __weak typeof(self) weakSelf = self;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确定重新闯关？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.gameIndex = 3;
        [strongSelf loadGameWithIndex:strongSelf.gameIndex];
    }];
    [ac addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)handleBtn:(BWButton *)btn {
    [btn changeColor];
    if (btn.section != 0) {
        BWButton *upBtn = self.btnsArr[btn.section - 1][btn.row];
        [upBtn changeColor];
    }
    if (btn.row != 0) {
        BWButton *leftBtn = self.btnsArr[btn.section][btn.row - 1];
        [leftBtn changeColor];
    }
    if (btn.section != self.gameIndex - 1) {
        BWButton *downBtn = self.btnsArr[btn.section + 1][btn.row];
        [downBtn changeColor];
    }
    if (btn.row != self.gameIndex - 1) {
        BWButton *rightBtn = self.btnsArr[btn.section][btn.row + 1];
        [rightBtn changeColor];
    }
    
    self.step ++;
    self.stepLabel.text = [NSString stringWithFormat:@"Step: %zd", self.step];
    
    if ([self checkWin]) {
        [self showWinTip];
    }
}

- (void)handleTimer:(NSTimer *)timer {
    self.time ++;
    NSInteger minute = self.time / 60;
    NSInteger second = self.time % 60;
    NSString *minuteStr = minute < 10 ? [NSString stringWithFormat:@"0%zd", minute] : [NSString stringWithFormat:@"%zd", minute];
    NSString *secondStr = second < 10 ? [NSString stringWithFormat:@"0%zd", second] : [NSString stringWithFormat:@"%zd", second];
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@:%@", minuteStr, secondStr];
}

#pragma mark - LazyLoad
- (NSMutableArray *)btnsArr {
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray new];
    }
    return _btnsArr;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - Init
- (instancetype)initVC {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MainVC class])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end











