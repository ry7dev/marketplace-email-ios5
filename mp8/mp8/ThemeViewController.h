//
//  FirstViewController.h
//  mp8
//
//  Created by ryan luas on 4/22/12.
//  Copyright (c) 2012 ourseven design inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeViewController : UIViewController <UIScrollViewDelegate> {
    NSMutableArray *themes;

    IBOutlet UIImageView *iv;

    IBOutlet UIScrollView *sv;
    IBOutlet UIPageControl *pageControl;



}

@property (nonatomic, retain) NSMutableArray *themes;
@property (nonatomic, retain) UIScrollView *sv;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIImageView *iv;

-(NSString *)copyDatabaseToDocuments;

-(void) readThemesFromDatabaseWithPath:(NSString *)filePath;


@end
