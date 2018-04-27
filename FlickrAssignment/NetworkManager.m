//
//  NetworkManager.m
//  FlickrAssignment
//
//  Created by Tyler Boudreau on 2018-04-26.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager
-(void)FetchPhotoURLWithCompletionBlock:(void (^)(NSArray * array))completionBlock
 {
    
    NSURL *url =[NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=c9d0bf60b806129721e6ef9c9c86c7d1&tags=cat"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session =[NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"error %@",error.localizedDescription);
            return;
        }
        NSError *jsonError =nil;
        NSDictionary *catImages =[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if(jsonError){
            NSLog(@"jsonError: %@",jsonError.localizedDescription);
            return;
        }
        NSDictionary *photos = catImages[@"photos"];
        NSArray *array = photos[@"photo"];
        
        NSMutableArray *mutableUrls = [NSMutableArray new];

        for (NSDictionary *dict in array) {
            [mutableUrls addObject: [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",dict [@"farm"],dict[@"server"],dict[@"id"],dict[@"secret"]]];
        }
        
        NSArray *urls = [mutableUrls copy];
        
        completionBlock(urls);
        
                          }];
        [dataTask resume];
    
}

-(void)FetchPhotoWithURL:(NSString *)URL CompletionBlock:(void (^)(UIImage * image))completionBlock {
   
    
    NSURL *url = [NSURL URLWithString:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDownloadTask *download = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
    
            completionBlock(image);
    }];
    [download resume];
    
    
    
}


@end
