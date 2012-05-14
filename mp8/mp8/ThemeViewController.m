//
//  FirstViewController.m
//  mp8
//
//  Created by ryan luas on 4/22/12.
//  Copyright (c) 2012 ourseven design inc. All rights reserved.
//

#import "ThemeViewController.h"
#import "Theme.h"
#include <sqlite3.h>
@interface ThemeViewController ()

@end

@implementation ThemeViewController
@synthesize themes;



- (void)viewDidLoad
{
    [super viewDidLoad];
    /*NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(
                                                              NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    NSLog(@"my doc directory=%@",docDirectory);
    //reading/writing text content
    
    NSString *string = @"ourseven design inc.";
    NSString *filePath = [docDirectory stringByAppendingString:@"/File.txt"];
    [string writeToFile:filePath
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:nil];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", fileContents);
    NSString *tempDir = NSTemporaryDirectory();
    NSLog(@"%@", tempDir);*/
    //above, if you want to read a plain text file, you can use the NSString class method stringWithContentsOfFile:encoding:error: to read from the file..
    themes = [[NSMutableArray alloc] init];
    NSString *filePath = [self copyDatabaseToDocuments];
    [self readThemesFromDatabaseWithPath:filePath];
    
    

    
    [self.view setUserInteractionEnabled:YES];
    [self.view setMultipleTouchEnabled:YES];
    


	
}


- (NSString *)copyDatabaseToDocuments {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *filePath = [documentsPath
                          stringByAppendingPathComponent:@"mpe.sqlite"];
    
    if(![fileManager fileExistsAtPath:filePath]) {
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath]
                                stringByAppendingPathComponent:@"mpe.sqlite"];
		[fileManager copyItemAtPath:bundlePath toPath:filePath error:nil];
	}
    return filePath;
}

-(void) readThemesFromDatabaseWithPath:(NSString *)filePath {
    sqlite3 *database;
    
    if(sqlite3_open([filePath UTF8String], &database) == SQLITE_OK){
        const char *sqlStatement = "select * from templates";
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement,
                              -1, &compiledStatement,NULL) == SQLITE_OK){
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                NSString *themeName =
                [NSString stringWithUTF8String:(char *)
                 sqlite3_column_text(compiledStatement, 1)];
                NSString *themeDescription =
                [NSString stringWithUTF8String:(char *)
                 sqlite3_column_text(compiledStatement, 2)];
                
                /*NSData *themeData = [[NSData alloc]
                 initWithBytes:sqlite3_column_blob(compiledStatement, 3)
                 length: sqlite3_column_bytes(compiledStatement, 3)];*/
                NSString *themePicture = 
                [NSString stringWithUTF8String:(char *)
                 sqlite3_column_text(compiledStatement, 3)];
                UIImage *themeImage = [UIImage imageNamed:(themePicture)];
 
                
                //UIImage *themeImage = [UIImage imageWithData:themeData];
                
                Theme *newTheme = [[Theme alloc] init];
                newTheme.themeName = themeName;
                newTheme.themeDescription = themeDescription;
                newTheme.themePicture = (UIImage *)themeImage;
                //NSLog(@"theme image is:: %@",themePicture);

                NSString *str = [[NSBundle mainBundle] pathForResource:themePicture ofType:nil inDirectory:@""];
                UIScrollView *scrollView = [[UIScrollView alloc]
                                            initWithFrame:CGRectMake(10,10,self.view.frame.size.width,self.view.frame.size.height)];
                
                
                //scrollable content size...
                scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 35,
                                                    self.view.frame.size.height + 360);
                [scrollView flashScrollIndicators];
                
                self.view = [[UIPageControl alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                

                
                [scrollView setPagingEnabled:YES];
                scrollView.showsHorizontalScrollIndicator = YES;
                //scrollView insets
                scrollView.contentInset = UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
                scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
                
                UIView *awsmView = [[UIView alloc]
                                    initWithFrame:CGRectMake(10,10,self.view.frame.size.width,self.view.frame.size.height)];

                
                UIImageView *singleImageView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:str]];

                
                
                [scrollView addSubview:singleImageView];
                [scrollView addSubview:awsmView];
                scrollView.minimumZoomScale=0.5;
                scrollView.maximumZoomScale=6.0;

                NSLog(@"theme image is:: %@",str);
                
                



                [self.themes addObject:newTheme];
                [self.view addSubview:scrollView];


                
                
			}
		}
		sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end