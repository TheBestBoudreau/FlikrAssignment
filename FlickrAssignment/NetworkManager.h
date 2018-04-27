//
//  NetworkManager.h
//  FlickrAssignment
//
//  Created by Tyler Boudreau on 2018-04-26.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CATS.h"
@interface NetworkManager : NSObject
-(void)FetchPhotoURLWithCompletionBlock:(void (^)(NSArray * array))completionBlock;
-(void)FetchPhotoWithURL:(NSString *)URL CompletionBlock:(void (^)(UIImage * image))completionBlock ;
@end
