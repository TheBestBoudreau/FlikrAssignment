//
//  ViewController.m
//  FlickrAssignment
//
//  Created by Tyler Boudreau on 2018-04-26.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "ViewController.h"
#import "CATS.h"
#import "CollectionViewCell.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) NSMutableArray *catImageArray;
@property UICollectionViewFlowLayout *defaultLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _catImageArray = [NSMutableArray new];
    [self setupdefaultLayout];

    self.myCollectionView.collectionViewLayout=self.defaultLayout;

    
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
        NSArray *array = photos [@"photo"];
        for (NSDictionary *dict in array) {
//            NSLog(@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",dict [@"farm"],dict[@"server"],dict[@"id"],dict[@"secret"]);
            CATS *cats = [CATS new];
            cats.catURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",dict [@"farm"],dict[@"server"],dict[@"id"],dict[@"secret"]];
//            cats.catImages = [UIImage imageNamed:cats.catURL];
            
            NSURL *url = [NSURL URLWithString:cats.catURL];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            
            NSURLSessionDownloadTask *download = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error){
                    NSLog(@"error: %@", error.localizedDescription);
                    return;
                }
                NSData *data = [NSData dataWithContentsOfURL:location];
                UIImage *image = [UIImage imageWithData:data];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cats.catImages = image;

                }];
            }];
            [download resume];
            [self.catImageArray addObject:cats];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.myCollectionView reloadData];
        }];
    }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.catImageArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CollectionViewCell *cell =[self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"Cellid" forIndexPath:indexPath];
    

    for (CATS *cats in self.catImageArray) {
        cell.myImageView.image=cats.catImages;
[self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
    }

    return cell;
}

-(void)setupdefaultLayout{
    
    self.defaultLayout = [[UICollectionViewFlowLayout alloc]init];
    self.defaultLayout.itemSize = CGSizeMake(300, 250);
    self.defaultLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.defaultLayout.minimumInteritemSpacing=5;
    self.defaultLayout.minimumLineSpacing=10;
    self.defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.defaultLayout.headerReferenceSize = CGSizeMake(200, 0);
    
}

@end
