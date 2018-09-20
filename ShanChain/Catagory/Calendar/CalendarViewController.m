//
//  CalarViewController.m
//  TimeTest
//
//  Created by LvJianfeng on 16/7/21.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "CalendarViewController.h"
#import "NSDate+Formatter.h"

#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)

#define HeaderViewHeight 30
#define WeekViewHeight 40

@interface CalendarViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIButton         *lastBtn;
@property(nonatomic,strong)UIButton         *nextBtn;

@property(nonatomic,strong)UIButton     *startTimeBtn;
@property(nonatomic,strong)UIButton     *endTimeBtn;

@property(nonatomic,strong)UIView       *popView;
@property(nonatomic,strong)UIView   *registerBgView;

@property (strong, nonatomic) NSDate *tempDate;
@end

@implementation CalendarViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.popView.hidden=YES;
    self.registerBgView.hidden=YES;
}

- (void)dealloc{
    [self.registerBgView removeFromSuperview];
    [self.popView removeFromSuperview];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择时间";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubViews];
    
    self.tempDate = [NSDate date];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:RGB(102, 102, 102)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)setupSubViews{
    [self.view addSubview:self.lastBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.startTimeBtn];
    [self.view addSubview:self.endTimeBtn];
    [self.view addSubview:self.popView];
    
    self.popView.hidden=YES;
    self.registerBgView.hidden=YES;

}

-(void)closeTap{
    [UIView animateWithDuration:0.25 animations:^{
        self.registerBgView.hidden=YES;
        self.popView.hidden=YES;
    }];
}

- (void)getDataDayModel:(NSDate *)date{
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
}

-(void)sureAction{
//    NSLog(@"点击了确定");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = RGB(102, 102, 102);
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0; i < self.dayModelArray.count; i++) {
        id m = self.dayModelArray[i];
        if ([m isKindOfClass:[MonthModel class]]) {
            MonthModel *model = (MonthModel *)m;
            if (i == indexPath.row) {
                self.dateLabel.text = [(MonthModel *)model dateValue].yyyyMMddByLineWithDate;
                model.isSelectedDay = YES;
            }else{
                model.isSelectedDay = NO;
            }
        }
    }
    [self.collectionView reloadData];
    
//    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
//    id mon = self.dayModelArray[indexPath.row];
//    if ([mon isKindOfClass:[MonthModel class]]) {
//        cell.monthModel = (MonthModel *)mon;
//        self.dateLabel.text = [(MonthModel *)mon dateValue].yyyyMMddByLineWithDate;
//        cell.monthModel.isSelectedDay = YES;
//    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        NSInteger width = Iphone6Scale(54);
        NSInteger height = Iphone6Scale(54);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dateLabel.frame) + 22, width * 7, LL_SCREEN_HEIGHT - 64 - WeekViewHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}

-(UIButton *)lastBtn{
    if (!_lastBtn) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastBtn.frame = CGRectMake((30.0/375) *SCREEN_WIDTH, (30.0/667) * SCREEN_HEIGHT, 12, 16);
        [_lastBtn setImage:[UIImage imageNamed:@"calendar_btn_right_default"] forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(lastBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

-(void)lastBtnClicked{
    self.tempDate = [self getLastMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake((330.0/375) *SCREEN_WIDTH, (30.0/667) * SCREEN_HEIGHT, 12, 16);
        [_nextBtn setImage:[UIImage imageNamed:@"calendar_btn_left_default"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (130.0/375)* SCREEN_WIDTH)/2, (25.0/667) * SCREEN_HEIGHT, (130.0/375) * SCREEN_WIDTH, 22)];
        _dateLabel.textColor = RGB(44, 49, 53);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:16];
    }
    return _dateLabel;
}

-(void)nextBtnClicked{
    self.tempDate = [self getNextMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}

-(UIButton *)startTimeBtn{
    if (!_startTimeBtn) {
        _startTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startTimeBtn.frame = CGRectMake((38.0/375) * SCREEN_WIDTH, (505.0/667) *SCREEN_HEIGHT, (120.0/375) * SCREEN_WIDTH, (40.0/667) *SCREEN_HEIGHT);
        [_startTimeBtn setBackgroundImage:[UIImage imageNamed:@"calendar_btn_start_default"] forState:UIControlStateNormal];
        [_startTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        _startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_startTimeBtn addTarget:self action:@selector(startTimeAction) forControlEvents:UIControlEventTouchUpInside];
        _startTimeBtn.adjustsImageWhenHighlighted = NO;
        
    }
    return _startTimeBtn;
}

-(UIButton *)endTimeBtn{
    if (!_endTimeBtn) {
        _endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _endTimeBtn.frame = CGRectMake((220.0/375) * SCREEN_WIDTH, (505.0/667) *SCREEN_HEIGHT, (120.0/375) * SCREEN_WIDTH, (40.0/667) *SCREEN_HEIGHT);
        [_endTimeBtn setBackgroundImage:[UIImage imageNamed:@"calendar_btn_end_default"] forState:UIControlStateNormal];
        [_endTimeBtn setTitleColor:RGB(59, 187, 202) forState:UIControlStateNormal];
        _endTimeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        [_endTimeBtn addTarget:self action:@selector(endtTimeAction) forControlEvents:UIControlEventTouchUpInside];
        _endTimeBtn.adjustsImageWhenHighlighted = NO;
    }
    return _endTimeBtn;
}

-(void)startTimeAction{
    
    UIView *registerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    registerBgView.backgroundColor = RGBA(216, 216, 216, 0.5);
    self.registerBgView = registerBgView;
#warning 取出最上面的View
    [[[[UIApplication sharedApplication]windows]lastObject]addSubview:registerBgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    registerBgView.userInteractionEnabled = YES;
    [registerBgView addGestureRecognizer:tap];
    
    UIView *popView=[[UIView alloc]init];
    popView.frame = CGRectMake((SCREEN_WIDTH-(250.0/375) * SCREEN_WIDTH)/2, (140.0/667) * SCREEN_HEIGHT , (250.0/375) * SCREEN_WIDTH, (357.0/667) * SCREEN_HEIGHT);
    popView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, popView.size.width, (84.0/667) * SCREEN_HEIGHT)];
    bgHeadView.backgroundColor = RGB(57, 187, 202);
    
    UIButton *hourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hourBtn.frame = CGRectMake((88.0/375) * SCREEN_WIDTH, (15.0/667) * SCREEN_HEIGHT, (43.0/375) * SCREEN_WIDTH, (63.0/667) * SCREEN_HEIGHT);
    [hourBtn setTitle:@"3:" forState:UIControlStateNormal];
    [hourBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    hourBtn.titleLabel.font = [UIFont systemFontOfSize:54];
    [hourBtn addTarget:self action:@selector(hourAciton) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:hourBtn];
    
    UIButton *minuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minuteBtn.frame = CGRectMake((131.0/375) * SCREEN_WIDTH, (15.0/667) * SCREEN_HEIGHT, (63.0/375) * SCREEN_WIDTH, (63.0/667) * SCREEN_HEIGHT);
    [minuteBtn setTitle:@"30" forState:UIControlStateNormal];
    [minuteBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    minuteBtn.titleLabel.font = [UIFont systemFontOfSize:54];
    [minuteBtn addTarget:self action:@selector(minuteAction) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:minuteBtn];
    
    UIButton *amBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    amBtn.frame = CGRectMake((200.0/375) *SCREEN_WIDTH, (27.0/667) *SCREEN_HEIGHT, (22.0/375) * SCREEN_WIDTH, (24.0/667) * SCREEN_HEIGHT);
    [amBtn setTitle:@"AM" forState:UIControlStateNormal];
    amBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [amBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [amBtn addTarget:self action:@selector(amBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:amBtn];
    
    UIButton *pmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pmBtn.frame = CGRectMake((200.0/375) *SCREEN_WIDTH, (46.0/667) *SCREEN_HEIGHT, (22.0/375) * SCREEN_WIDTH, (24.0/667) * SCREEN_HEIGHT);
    [pmBtn setTitle:@"PM" forState:UIControlStateNormal];
    pmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pmBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [pmBtn addTarget:self action:@selector(pmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:pmBtn];
    
    
    [popView addSubview:bgHeadView];
    
    
    
    self.popView=popView;
    [self.registerBgView addSubview:popView];
    
}

-(void)endtTimeAction{
    UIView *registerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    registerBgView.backgroundColor = RGBA(216, 216, 216, 0.5);
    self.registerBgView = registerBgView;
#warning 取出最上面的View
    [[[[UIApplication sharedApplication]windows]lastObject]addSubview:registerBgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    registerBgView.userInteractionEnabled = YES;
    [registerBgView addGestureRecognizer:tap];
    
    UIView *popView=[[UIView alloc]init];
    popView.frame = CGRectMake((SCREEN_WIDTH-(250.0/375) * SCREEN_WIDTH)/2, (140.0/667) * SCREEN_HEIGHT , (250.0/375) * SCREEN_WIDTH, (357.0/667) * SCREEN_HEIGHT);
    popView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, popView.size.width, (84.0/667) * SCREEN_HEIGHT)];
    bgHeadView.backgroundColor = RGB(57, 187, 202);
    
    UIButton *hourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hourBtn.frame = CGRectMake((88.0/375) * SCREEN_WIDTH, (15.0/667) * SCREEN_HEIGHT, (43.0/375) * SCREEN_WIDTH, (63.0/667) * SCREEN_HEIGHT);
    [hourBtn setTitle:@"3:" forState:UIControlStateNormal];
    [hourBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    hourBtn.titleLabel.font = [UIFont systemFontOfSize:54];
    [hourBtn addTarget:self action:@selector(hourAciton) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:hourBtn];
    
    UIButton *minuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minuteBtn.frame = CGRectMake((131.0/375) * SCREEN_WIDTH, (15.0/667) * SCREEN_HEIGHT, (63.0/375) * SCREEN_WIDTH, (63.0/667) * SCREEN_HEIGHT);
    [minuteBtn setTitle:@"30" forState:UIControlStateNormal];
    [minuteBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    minuteBtn.titleLabel.font = [UIFont systemFontOfSize:54];
    [minuteBtn addTarget:self action:@selector(minuteAction) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:minuteBtn];
    
    UIButton *amBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    amBtn.frame = CGRectMake((200.0/375) *SCREEN_WIDTH, (27.0/667) *SCREEN_HEIGHT, (22.0/375) * SCREEN_WIDTH, (24.0/667) * SCREEN_HEIGHT);
    [amBtn setTitle:@"AM" forState:UIControlStateNormal];
    amBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [amBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [amBtn addTarget:self action:@selector(amBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:amBtn];
    
    UIButton *pmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pmBtn.frame = CGRectMake((200.0/375) *SCREEN_WIDTH, (46.0/667) *SCREEN_HEIGHT, (22.0/375) * SCREEN_WIDTH, (24.0/667) * SCREEN_HEIGHT);
    [pmBtn setTitle:@"PM" forState:UIControlStateNormal];
    pmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [pmBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    [pmBtn addTarget:self action:@selector(pmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgHeadView addSubview:pmBtn];
    
    
    [popView addSubview:bgHeadView];
    
    self.popView=popView;
    [self.registerBgView addSubview:popView];
    
}

#pragma mark -Private

-(void)hourAciton{
    NSLog(@"点击了小时");
}

-(void)amBtnClick{
    NSLog(@"点击了上午");
}

-(void)minuteAction{
    NSLog(@"点击了分钟");
}

-(void)pmBtnClick{
    NSLog(@"点击了下午");
    
}

- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;

}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

@end

@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"SU",@"M",@"TU",@"W",@"TH",@"F",@"SA", nil];
        
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*Iphone6Scale(54), 0, Iphone6Scale(54), HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor grayColor];
            weekLabel.font = [UIFont systemFontOfSize:13.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
        
    }
    return self;
}
@end


@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius =2;
        
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    if (monthModel.isSelectedDay) {
        self.dayLabel.backgroundColor = RGB(59, 187, 202);
        self.dayLabel.textColor = [UIColor whiteColor];
    }
}

@end


@implementation MonthModel

@end
