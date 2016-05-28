//
//  WTRecorderWave.h
//  WTEnjoyVoice
//
//  Created by 隋文涛 on 16/5/27.
//  Copyright © 2016年 wintelsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRecorderWave : UIView

IBInspectable @property float sampleWidth;
IBInspectable @property float intervalTime;
@property (nonatomic, strong) NSMutableArray *samples;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addSamples:(NSNumber *)value;
@end
