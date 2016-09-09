//
//  FFStarRatingView.h
//  FFStarRatingView
//
//  Created by caozhen@neusoft on 16/9/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//  星级 或者 星级评分

#import <UIKit/UIKit.h>

@class FFStarRatingView;

@protocol FFStarRatingViewDelegate <NSObject>

- (void)starRatingView:(FFStarRatingView *)starView score:(CGFloat)score;


@end

@interface FFStarRatingView : UIView

@property (nonatomic,readonly) NSInteger numberOfStars;

@property (nonatomic,weak)   id<FFStarRatingViewDelegate> delegate;



- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)stars;

- (void)setScore:(CGFloat)score withAnim:(BOOL)isAnim;

- (void)setScore:(CGFloat)score withAnim:(BOOL)isAnim completion:(void(^)(BOOL isFinish))completion;

@end
