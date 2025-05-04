//
//  UIAppearance+Swift.m
//  Chameleon
//
//  Created by Vicc Alexander on 11/26/15.
//  Copyright © 2015 Vicc Alexander. All rights reserved.
//

#import "UIAppearance+Swift.h"

@implementation UIView (UIViewAppearance_Swift)

+ (instancetype)appearanceWhenContainedWithin:(NSArray<Class<UIAppearanceContainer>> *)containers {
    return [self appearanceWhenContainedInInstancesOfClasses:containers];
}


@end
