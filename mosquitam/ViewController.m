//
//  ViewController.m
//  mosquitam
//
//  Created by Cosaki on 2015/01/31.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize listView;

// ???:通知、アラームを鳴らす
//
- (void)viewDidLoad
{
    [super viewDidLoad];    pl=0;
    
    saveData = [NSUserDefaults standardUserDefaults]; //初期化
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    
    if (!saveDataArray.count) {
        
        saveDataArray = [NSMutableArray array];
    }


    
#ifdef DEBUG
        NSLog(@"%@",saveDataArray);
#endif
    [listView reloadData];

    [listView setDataSource:self];
    [listView setDelegate:self];
}

//willじゃなくてdid
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    saveData = [NSUserDefaults standardUserDefaults];
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];

    if (!saveDataArray.count) {
        
        saveDataArray = [NSMutableArray array];
    }
#ifdef DEBUG
    NSLog(@"%@",saveDataArray);
#endif
    [listView reloadData];
}


//-(IBAction)alarmLocalNotificationDidAppear:(id)sender{
//    
//    //つくる
//    alarmLocalNotification = [[UILocalNotification alloc] init];
//    //じかん
//    alarmLocalNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(20)];
//    //きじゅん
//    alarmLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
//    //ぶんしょう
//    alarmLocalNotification.alertBody = @"ああああああ";
////    //さうんど
////    alarmLocalNotification.soundName = /* モスキート音鳴らす */;
//    
//    //とうろく
//    [[UIApplication sharedApplication] scheduleLocalNotification:alarmLocalNotification];
//    
//    
//}
//

+ (void)addLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *selectedWeek = [userDefaults arrayForKey:@"week"];
    NSDate *notificationTime = [userDefaults objectForKey:@"time"];
    
    NSInteger repeartCount = 7;
    NSDate *today = [NSDate date];
    NSDate *date;
    NSString *dateString;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    
    /* autorelease #とは 
     いらないやつのこと */
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd hh:mm";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    timeFormat.dateFormat = @"hh:mm";
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    for (NSInteger i = 0; i < repeartCount; i++) {
        date = [today dateByAddingTimeInterval:i * 24 * 60 * 60];
        dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
        
        if ([selectedWeek containsObject:[NSNumber numberWithInteger:dateComponents.weekday - 1]]) {
            // Adding the local notification.
            dateString = [NSString stringWithFormat:@"%@ %@",
                          [dateFormat stringFromDate:date],
                          [timeFormat stringFromDate:notificationTime]];
            
            if ([today compare:[format dateFromString:dateString]] == NSOrderedAscending) {
                notification.fireDate = [format dateFromString:dateString];
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.alertBody = [NSString stringWithFormat:@"Notify:%@", dateString];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.alertAction = @"Open";
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//変換 10→2進数
/*
-(int)outputBinaryValue:(int)normalValue{
    
//    NSString *flags = nowIndexPathDictionary[@"dayFlags"];
//    [NSString stringWithFormat:@"%d", dayFlags];
    
    //input
    ten = normalValue;
    int two[16];
    
    //change
    for(int i=0; i<16; i++){
        two[i] = ten % 2;
        ten = ten / 2;
    }
    
    //output
    NSMutableString *outPut = [NSMutableString string];
    for (int i=16-1; i>=0; i--) {
        [outPut appendFormat:@"%d",two[i]];
    }
    NSLog(@"outPut:%@",outPut);
    return [outPut intValue];
}
*/

- (NSString *)changeIntegerToDayString:(NSInteger)dayNumber {
    NSString *dayString;
    switch (dayNumber) {
        case 1:
            dayString = @"日";
            break;
        case 2:
            dayString = @"月";
            break;
        case 3:
            dayString = @"火";
            break;
        case 4:
            dayString = @"水";
            break;
        case 5:
            dayString = @"木";
            break;
        case 6:
            dayString = @"金";
            break;
        case 7:
            dayString = @"土";
            break;
            
        default:
            break;
    }
    return dayString;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; //とりあえずセクションは1個
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return saveDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //カスタムセルを選ぶ
    static NSString *CellIdentifier = @"xxxcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSMutableDictionary *nowIndexPathDictionary = saveDataArray[indexPath.row];
    
    
    //各要素にはタグでアクセスする
    UILabel *reNameLabel = (UILabel*)[cell viewWithTag:1];
    reNameLabel.text = nowIndexPathDictionary[@"reNameStr"];
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:2];
    timeLabel.text = nowIndexPathDictionary[@"timeKey"];
    UILabel *dayLabel = (UILabel*)[cell viewWithTag:3];
    //FIXME:ここに曜日
    NSInteger dayFlags = [nowIndexPathDictionary[@"dayFlags"] integerValue];
    dayLabel.text = [self changeIntegerToDayString:dayFlags];
    
    //Switch
    changeSwitch = (UISwitch*)[cell viewWithTag:4];
    [changeSwitch addTarget:self action:@selector(tapSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    if (isEdit == YES) {
        
        changeSwitch.hidden = YES; // 表示
        
    } else {
        
        changeSwitch.hidden = NO; // 非表示
        
    }

    
    return cell;
    
}



// UISwitchがタップされた際に呼び出されるメソッド。
-(void)tapSwitch:(id)sender {
    changeSwitch = (UISwitch *)sender;
    NSLog(@"switch tapped. value = %@", (changeSwitch.on ? @"ON" : @"OFF"));
}


-(void)reloadDate{
    
    [listView reloadData];
}

- (IBAction)editAction:(id)sender{
    if (isEdit == YES) {
        
        [listView setEditing:NO];
        isEdit = NO;
        editBarButton.title = @"Edit";
        
    } else {
        
        [listView setEditing:YES];
        isEdit = YES;
        editBarButton.title = @"Set";
        
    }
    
    [listView reloadData];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [saveDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        
        [saveData setObject:saveDataArray forKey:@"list"];
    }
}


@end
