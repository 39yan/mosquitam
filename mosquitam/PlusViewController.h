//
//  PlusViewController.h
//  mosquitam
//
//  Created by Cosaki on 2015/02/25.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);

enum {
    None = 0,
    Sunday = 1 << 0,
    Monday = 1 << 1,
    Tuesday = 1 << 2,
    Wednesday = 1 << 3,
    Thursday = 1 << 4,
    Friday = 1 << 5,
    Saturday = 1 << 6,
    All = Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday
};

@interface PlusViewController : UIViewController<UITextFieldDelegate>{
    
    AudioUnit aU;
    UInt32 bitRate;
    
    //labelname
    IBOutlet UITextField *reNameTextField;

    //frequency
    IBOutlet UISlider *fqcSlider;
    IBOutlet UILabel *fqcLabel;
    
    //others settings
    IBOutlet UISwitch *brtSwitch;
    IBOutlet UISwitch *snzSwitch;
    IBOutlet UISwitch *fdinSwitch;
    
    //DatePicker
    IBOutlet UIDatePicker *timeDatePicker;
    
    //save
    NSUserDefaults *saveData;
    NSMutableDictionary *saveDataDictionary;
    NSMutableArray *saveDataArray;
    
    //variable
    int fqc;
    
    //NSDictionary
    NSString *fqcStr;
    NSString *reNameStr;
    
    BOOL brtBool;
    BOOL snzBool;
    BOOL fdinBool;
    
//    BOOL sunBool;
//    BOOL satBool;
    
    NSInteger dayFlags;
    
    NSDate *dateTime;
    
    NSString *timeStr;
    
}


-(IBAction)saveAlerm;

-(IBAction)changeBrtSwitch;
-(IBAction)changeSnzSwitch;
-(IBAction)changeFdinSwitch;

-(IBAction)dateTapped:(UIButton *)sender;
-(IBAction)timeChanged;

@property (nonatomic) double phase;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) Float64 frequency;


@end
