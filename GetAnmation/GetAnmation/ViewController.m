//
//  MGGetMagAnimationViewController.m
//  MaggieDating
//
//  Created by 包曙源 on 2018/4/9.
//  Copyright © 2018年 com.maggie.social.maggieDating. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+EnlargeTouchArea.h"
#import <AVFoundation/AVFoundation.h>
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kKeyWindow [UIApplication sharedApplication].keyWindow

@interface ViewController ()<CAAnimationDelegate>
@property(nonatomic,assign)NSInteger tags;
@property( nonatomic, strong)NSMutableArray *arrs;
@property( nonatomic, strong)NSMutableArray *tagArr;
@property( nonatomic, strong)UIButton *centerBrn;
@property( nonatomic, strong)UIButton *myAcc;
@property( nonatomic, strong)NSMutableArray *arr;
@property( nonatomic, strong)NSMutableArray *accCount;

@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property( nonatomic, strong)NSMutableArray *maglist;
@property( nonatomic, strong)NSMutableArray *moreArr;
@property( nonatomic, strong)NSURLSessionDataTask *task;
@property(nonatomic,strong)UIView *noDataView;

@end

@implementation ViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _centerBrn.alpha = 0;
    [_centerBrn removeFromSuperview];
    for (UIButton *btn in _arrs) {
        [btn removeFromSuperview];
    }
    [_tagArr removeAllObjects];
    [_arrs removeAllObjects];
    [_arr removeAllObjects];
}
- (UIButton *)centerBrn {
    if (!_centerBrn) {
        _centerBrn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_centerBrn setBackgroundImage:[UIImage imageNamed:@"矿晶"] forState:(UIControlStateNormal)];
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(-5, 60, 60, 10)];
        la.text = @"正在生长中";
        la.textAlignment = NSTextAlignmentCenter;
        la.font = [UIFont systemFontOfSize:11];
        la.textColor = [UIColor whiteColor];
        [_centerBrn addSubview:la];
        _centerBrn.alpha = 0;
    }
    return _centerBrn;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tagArr removeAllObjects];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
  

}

- (void)createArr {
    BOOL mark = YES;
    NSInteger randomCPX =50+ arc4random() % (int)(self.view.frame.size.width-120);
    NSInteger randomCPY =64+56*kScreenHeight/667+55+ arc4random() % (int)(kScreenHeight/4*3-275);
    for (NSValue *value in _arr) {
        if (sqrt(pow([value CGPointValue].x - randomCPX, 2) + pow( [value CGPointValue].y - randomCPY, 2)) <= 70) {
            mark=NO;
            break ;
        }
    }
    if (mark == YES) {
        [_arr addObject:[NSValue valueWithCGPoint:CGPointMake(randomCPX, randomCPY)]];
    }
    if (_arr.count <8) {
        [self createArr];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
}
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        NSError * error;
        NSString *str = [[NSBundle mainBundle] pathForResource:@"get" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:str];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:&error];
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.volume = 0.1;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"error - %@",error);
        }else{
            NSLog(@"播放");
        }
    }
    return _audioPlayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _maglist = [NSMutableArray array];
    _moreArr = [NSMutableArray array];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    _arrs = [NSMutableArray array];
    _arr = [NSMutableArray array];
    _accCount = [NSMutableArray array];
    _tagArr = [NSMutableArray array];
    NSInteger randomCPX =50+ arc4random() % (int)(self.view.frame.size.width-120);
    NSInteger randomCPY =65+56*kScreenHeight/667+55+ arc4random() % (int)(kScreenHeight/4*3-275);
    [_arr addObject:[NSValue valueWithCGPoint:CGPointMake(randomCPX, randomCPY)]];
    [self createArr];
    UIImageView *head = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight/4*3)];
    head.userInteractionEnabled = YES;
    head.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:head];
    for (int i = 0; i < 8; i++) {
        UIButton *layer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(-25, 56, 100, 10)];
        la.text = @"0.12345";
        la.tag = 1000+i;
        la.textAlignment = NSTextAlignmentCenter;
        la.font = [UIFont systemFontOfSize:11];
        [layer addSubview:la];
        layer.tag = 900+i;
        la.textColor = [UIColor whiteColor];
        [layer setBackgroundColor:[UIColor redColor]] ;
        [_arrs addObject:layer];
    }
    for (int i = 0; i < 8; i ++) {
        UIButton *layer =[_arrs objectAtIndex:i];
        [layer setEnlargeEdgeWithTop:30 right:5 bottom:5 left:5];
        layer.tag = 900+i;
        CGPoint point = [[_arr objectAtIndex:i] CGPointValue];
        layer.center = point;
        [head addSubview:layer];
        [layer addTarget:self action:@selector(move:) forControlEvents:(UIControlEventTouchUpInside)];
        [head.layer addSublayer:[self createpath:CGPointMake(0, kScreenHeight/4*3-60) btn:layer]];
        [layer.layer addAnimation:[self opacityForever_Animation:1 start:0.0f end:1.0f] forKey:nil];
        if (0.5*i >1) {
            [layer.layer addAnimation:[self centerChange:1.25 y:layer.frame.origin.y] forKey:@"position"];
        }else{
            [layer.layer addAnimation:[self centerChange:1.5 y:layer.frame.origin.y] forKey:@"position"];
        }
        layer.center = layer.center;
    }
    self.centerBrn.center = CGPointMake(head.center.x, kScreenHeight/4*3/2);
    if (_accCount.count == 0) {
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.centerBrn.layer addAnimation:[self centerChange:0.9 y:self.centerBrn.frame.origin.y] forKey:@"position"];
        });
        NSArray *_centerBrnArray = [NSArray arrayWithObjects:[self opacityForever_Animation:0.0 start:0.0f end:0.0f], nil];
        [_centerBrn.layer addAnimation:[self groupAnimations:_centerBrnArray durTimes:0.0 Rep:0] forKey:nil];
    }
    [head addSubview:self.centerBrn];
    _myAcc = [UIButton buttonWithType:UIButtonTypeCustom];
    _myAcc.frame = CGRectMake(15, kScreenHeight/4*3-115, 80, 80);
    [_myAcc addTarget:self action:@selector(myMoney) forControlEvents:(UIControlEventTouchUpInside)];
    _myAcc.titleLabel.font = [UIFont systemFontOfSize: 13]; //标题字体大小
    _myAcc.titleLabel.textAlignment = NSTextAlignmentCenter; //设置标题的字体居
    [_myAcc setTitle:@"我的麦粒" forState:(UIControlStateNormal)];
    [_myAcc setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_myAcc setBackgroundImage:[UIImage imageNamed:@"我的麦粒有阴影"] forState:(UIControlStateNormal)];
    //    [myAcc setImage:[UIImage imageNamed:@"组"] forState:(UIControlStateNormal)];
    CGFloat offset = 170;
    _myAcc.titleEdgeInsets = UIEdgeInsetsMake(0, -_myAcc.imageView.frame.size.width, -_myAcc.imageView.frame.size.height-offset/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    _myAcc.imageEdgeInsets = UIEdgeInsetsMake(-_myAcc.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -_myAcc.titleLabel.intrinsicContentSize.width);
    [head addSubview:_myAcc];
    UIButton *addAcc = [UIButton buttonWithType:UIButtonTypeCustom];
    addAcc.frame = CGRectMake(95,  kScreenHeight/4*3-115, 80, 80);
    addAcc.titleLabel.font = [UIFont systemFontOfSize: 13]; //标题字体大小
    addAcc.titleLabel.textAlignment = NSTextAlignmentCenter; //设置标题的字体
    [addAcc setTitle:@"提升生长力" forState:(UIControlStateNormal)];
    [addAcc setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [addAcc setBackgroundImage:[UIImage imageNamed:@"提升活力"] forState:(UIControlStateNormal)];
    //    [addAcc setImage:[UIImage imageNamed:@"组"] forState:(UIControlStateNormal)];
    [addAcc addTarget:self action:@selector(addMoney) forControlEvents:(UIControlEventTouchUpInside)];
    addAcc.titleEdgeInsets = UIEdgeInsetsMake(0, -addAcc.imageView.frame.size.width, -addAcc.imageView.frame.size.height-offset/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    addAcc.imageEdgeInsets = UIEdgeInsetsMake(-addAcc.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -addAcc.titleLabel.intrinsicContentSize.width);
    [head addSubview:addAcc];
    UIButton *giveAcc = [UIButton buttonWithType:UIButtonTypeCustom];
    giveAcc.frame = CGRectMake(kScreenWidth-100,  kScreenHeight/4*3-115, 80, 80);
    giveAcc.titleLabel.font = [UIFont systemFontOfSize: 13]; //标题字体大小
    giveAcc.titleLabel.textAlignment = NSTextAlignmentCenter; //设置标题的字体
    [giveAcc setTitle:@"邀请好友" forState:(UIControlStateNormal)];
    [giveAcc setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [giveAcc setBackgroundImage:[UIImage imageNamed:@"邀请好友有阴影"] forState:(UIControlStateNormal)];
    //    [giveAcc setImage:[UIImage imageNamed:@"组"] forState:(UIControlStateNormal)];
    [giveAcc addTarget:self action:@selector(shareMoney) forControlEvents:(UIControlEventTouchUpInside)];
    giveAcc.titleEdgeInsets = UIEdgeInsetsMake(0, -giveAcc.imageView.frame.size.width, -giveAcc.imageView.frame.size.height-offset/2, 0);
    // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    giveAcc.imageEdgeInsets = UIEdgeInsetsMake(-giveAcc.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -giveAcc.titleLabel.intrinsicContentSize.width);
    [head addSubview:giveAcc];
}
- (void)move:(UIButton *)btn {
    _tags = btn.tag;
    [_tagArr addObject:@(_tags)];
    NSArray *myArray = [NSArray arrayWithObjects:[self keyframeAnimation:55 y:kScreenHeight/4*3-75 btn:btn],[self opacityForever_Animation:1 start:1.0f end:0.0f], nil];
    [btn.layer addAnimation:[self groupAnimation:myArray durTimes:0.5 Rep:1] forKey:nil];
    btn.center = CGPointMake(55, kScreenHeight/4*3-75);
    UILabel *la = [self.view viewWithTag:_tags+100];
    [la.layer addAnimation:[self opacityForever_Animation:1 start:1.0f end:0.0f] forKey:nil];
    [_arrs removeObject:btn];
    if (_arrs.count == 0) {
        if (_moreArr.count > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_arr removeAllObjects];
                [self createArr];
                [_accCount removeAllObjects];
                [_accCount addObjectsFromArray:_moreArr];
                [_moreArr removeAllObjects];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *_centerBrnArray = [NSArray arrayWithObjects:[self opacityForever_Animation:0.7 start:0.2f end:1.0f], nil];
                [_centerBrn.layer addAnimation:[self groupAnimations:_centerBrnArray durTimes:1 Rep:1] forKey:nil];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    UIButton *btn = [self.view viewWithTag:[num integerValue]];
                [btn removeFromSuperview];
            });
            
        }
    }
}

-(CABasicAnimation *) centerChange:(float)time y:(float)y{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue = [NSNumber numberWithFloat:y];
    animation.toValue = [NSNumber numberWithFloat:y+10];//这是位置。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 35;
    }
    return kScreenHeight/4*3;
}


- (void)myMoney {
   
}
- (void)addMoney{

}
-(void)shareMoney {
   
}


#pragma mark =====组合动画-=============
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}
-(CAAnimationGroup *)groupAnimations:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        self.audioPlayer = nil;
        self.audioPlayer.volume = 0.1;
        [self.audioPlayer play];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.duration = 0.2f;
        animation.values = @[@(0.9), @(1)];
        animation.calculationMode = kCAAnimationCubic;
        [_myAcc.layer addAnimation:animation forKey:@"scale"];
    }
}
#pragma mark === 透明度动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time start:(CGFloat)start end:(CGFloat)end
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:start];
    animation.toValue = [NSNumber numberWithFloat:end];//这是透明度。
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
#pragma mark === 沿轨迹运动动画 ======
-(CAKeyframeAnimation *)keyframeAnimation:(CGFloat)x y:(CGFloat)y btn:(UIButton *)btn{
    //创建运动的轨迹动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.5;
    pathAnimation.repeatCount = 1;
    [pathAnimation setAutoreverses:NO];
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGPathMoveToPoint(ovalfromarc, nil, btn.center.x, btn.center.y);
    CGPathAddLineToPoint(ovalfromarc, nil, x, y);
    //现在我们有路径，我们告诉动画我们要使用这个路径 - 然后我们释放路径
    pathAnimation.path = ovalfromarc;
    CGPathRelease(ovalfromarc);
    return pathAnimation;
}
#pragma mark === 创建轨迹 ======
- (CALayer *)createpath:(CGPoint)point btn:(UIButton *)btn{
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:CGPointMake(btn.center.x, btn.center.y)];
    // 其他点
    [linePath addLineToPoint:point];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor clearColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    return lineLayer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
   
}
@end

