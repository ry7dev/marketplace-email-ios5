//
//  Theme.h
//  mp8
//
//  Created by ryan luas on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject {
    NSString *themeName;
    NSString *themeDescription;
    UIImage  *themePicture;
}


@property (nonatomic, retain) NSString *themeName;
@property (nonatomic, retain) NSString *themeDescription;
@property (nonatomic, retain) IBOutlet UIImage *themePicture;
@end
