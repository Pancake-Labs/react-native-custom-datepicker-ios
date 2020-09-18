//
//  CustomDatePickerManager.m
//  datepicker
//
//  Created by Alexander Avakov on 04/02/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "CustomDatePickerManager.h"
#import "CustomDatePicker.h"

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

@implementation RCTConvert(UIDatePicker)

RCT_ENUM_CONVERTER(UIDatePickerMode, (@{
  @"time": @(UIDatePickerModeTime),
  @"date": @(UIDatePickerModeDate),
  @"datetime": @(UIDatePickerModeDateAndTime),
  @"countdown": @(UIDatePickerModeCountDownTimer),
}), UIDatePickerModeTime, integerValue)

@end

@implementation CustomDatePickerManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [CustomDatePicker new];
}

RCT_EXPORT_VIEW_PROPERTY(date, NSDate)
RCT_EXPORT_VIEW_PROPERTY(locale, NSLocale)
RCT_EXPORT_VIEW_PROPERTY(minimumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(maximumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(minuteInterval, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_REMAP_VIEW_PROPERTY(mode, datePickerMode, UIDatePickerMode)
RCT_REMAP_VIEW_PROPERTY(timeZoneOffsetInMinutes, timeZone, NSTimeZone)
RCT_CUSTOM_VIEW_PROPERTY(textColor, UIColor, CustomDatePicker)
{
  if(@available(ios 14,*)) {
    SEL setPreferredDatePickerStyleSelector = sel_registerName("setPreferredDatePickerStyle:");
    if ([view respondsToSelector:setPreferredDatePickerStyleSelector]) {
      // you cannot use a selector here as setPreferredDatePickerStyle expects a value type
      // and dynamic calls via selectors require reference-typed arguments under ARC
      NSMethodSignature *methodSignature = [view methodSignatureForSelector:setPreferredDatePickerStyleSelector];
      NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
      [invocation setSelector:setPreferredDatePickerStyleSelector];

      NSInteger style = UIDatePickerStyleWheels;

      // index 0,1 are reserved for super, self
      [invocation setArgument:&style atIndex:2];

      [invocation invokeWithTarget:view];
    }
  }

  UIColor *textColor = json ? [[UIColor alloc] initWithCGColor:[RCTConvert CGColor:json]] : [UIColor blackColor];
  [view setValue:textColor forKeyPath:@"textColor"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([view respondsToSelector:sel_registerName("setHighlightsToday:")]) {
    [view performSelector:@selector(setHighlightsToday:) withObject:[NSNumber numberWithBool:NO]];
  }
#pragma clang diagnostic pop
}

@end
