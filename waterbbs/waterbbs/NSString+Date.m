//
//  NSString+Date.m
//  waterbbs
//
//  Created by y on 15/12/17.
//  Copyright © 2015年 younfor. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSDate(Date)
- (NSString *)prettyDateWithReference: (NSDate *) reference
{
  NSString *suffix = @"";
  
  float different = [reference timeIntervalSinceDate:self];
  //NSLog(@"dif:%f",different);
  if (different < 0) {
    different = -different;
    suffix = @"从现在";
  }
  
  // days = different / (24 * 60 * 60), take the floor value
  float dayDifferent = floor(different / 86400);
  
  int days   = (int)dayDifferent;
  int weeks  = (int)ceil(dayDifferent / 7);
  int months = (int)ceil(dayDifferent / 30);
  int years  = (int)ceil(dayDifferent / 365);
  
  // It belongs to today
  if (dayDifferent <= 0) {
    // lower than 60 seconds
    if (different < 60) {
      return @"刚刚";
    }
    
    // lower than 120 seconds => one minute and lower than 60 seconds
    if (different < 120) {
      return [NSString stringWithFormat:@"1 分钟前 %@", suffix];
    }
    
    // lower than 60 minutes
    if (different < 60 * 60) {
      return [NSString stringWithFormat:@"%d 分钟前 %@", (int)floor(different / 60), suffix];
    }
    
    // lower than 60 * 2 minutes => one hour and lower than 60 minutes
    if (different < 7200) {
      return [NSString stringWithFormat:@"1 小时 %@", suffix];
    }
    
    // lower than one day
    if (different < 86400) {
      return [NSString stringWithFormat:@"%d 小时 %@", (int)floor(different / 3600), suffix];
    }
  }
  // lower than one week
  else if (days < 7) {
    return [NSString stringWithFormat:@"%d 天%@ %@", days, days == 1 ? @"" : @"s", suffix];
  }
  // lager than one week but lower than a month
  else if (weeks < 4) {
    return [NSString stringWithFormat:@"%d 周%@ %@", weeks, weeks == 1 ? @"" : @"s", suffix];
  }
  // lager than a month and lower than a year
  else if (months < 12) {
    return [NSString stringWithFormat:@"%d 月%@ %@", months, months == 1 ? @"" : @"s", suffix];
  }
  // lager than a year
  else {
    return [NSString stringWithFormat:@"%d 年%@ %@", years, years == 1 ? @"" : @"s", suffix];
  }
  
  return self.description;
}
@end
