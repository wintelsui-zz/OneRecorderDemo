//
//  WTRecorderWave.m
//  WTEnjoyVoice
//
//  Created by 隋文涛 on 16/5/27.
//  Copyright © 2016年 wintelsui. All rights reserved.
//

#import "WTRecorderWave.h"

@implementation WTRecorderWave
@synthesize samples;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)awakeFromNib
{
    [self setup];
}

- (void)setup{
    _sampleWidth = 0.5;
    _intervalTime = 0.015;
}

- (void)addSamples:(NSNumber *)value{
    if (self.samples == nil) {
        self.samples = [[NSMutableArray alloc] init];
    }
    [self.samples addObject:value];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] set];
    UIRectFill(self.bounds);
    
    [[UIColor lightGrayColor] set];
    float timeShort = 1.0;
    float timeLong = 0.0;
    for (u_int16_t i = 0; i<samples.count; i++) {
        float sample = [samples[i] floatValue];
        
        u_int16_t height = 0;
        if (sample >= -10) {
            if (sample >= 0) {
                sample = 0;
            }
            height = ((sample + 11.0) / 18.0)*(self.bounds.size.height - 20);
        }else{
            height = (-10.0 /sample) * (self.bounds.size.height - 20)/18;
        }
        CGRect rect = CGRectMake(i*_sampleWidth + 0.15, ((self.bounds.size.height - 20)-height)/2 + 20, _sampleWidth - 0.3, height);
        UIRectFill(rect);
        
        float time = i * _intervalTime;
        if (time == timeLong) {
            //长条带时间
            float x = i * _sampleWidth - 0.5;
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(x, 0, 1, 6)];
            [[UIColor whiteColor] setFill];
            [rectanglePath fill];
            
            {//时间
                float widthMax = ((1.0 / _intervalTime) * _sampleWidth);
                float xText = i * _sampleWidth - (widthMax / 2.0);
                {if(xText < 0) {xText = 0;}}
                CGContextRef context = UIGraphicsGetCurrentContext();
                NSString *textContent = [NSString stringWithFormat:@"%.0f",time];
                CGRect textRect = CGRectMake(xText, 8, widthMax, 12);
                NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                if (xText == 0) {
                    textStyle.alignment = NSTextAlignmentLeft;
                }else{
                    textStyle.alignment = NSTextAlignmentCenter;
                }
                NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 8.0f], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: textStyle};
                CGContextSaveGState(context);
                CGContextClipToRect(context, textRect);
                [textContent drawInRect:textRect withAttributes: textFontAttributes];
                CGContextRestoreGState(context);
            }
            
            timeLong += 2.0;
        }else if (time == timeShort) {
            //短线不带数字
            float x = i * _sampleWidth - 0.5;
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(x, 0, 1, 3)];
            [[UIColor whiteColor] setFill];
            [rectangle2Path fill];

            timeShort += 2.0;
        }
    }
    
    [[UIColor grayColor] setFill];
    UIBezierPath *centerLine = [UIBezierPath bezierPathWithRect:CGRectMake(0, round(((self.bounds.size.height - 20)/2)-0.5) + 20, self.bounds.size.width, 1)];
    [centerLine fill];
    
    float x = round(samples.count*_sampleWidth);
    CGRect darken = CGRectMake(x, 0 + 20, self.bounds.size.width-x, (self.bounds.size.height - 20));
    [[UIColor blackColor] set];
    UIRectFill(darken);

}

@end
