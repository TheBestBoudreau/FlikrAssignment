//
//  ViewController.m
//  FlickrAssignment
//
//  Created by Tyler Boudreau on 2018-04-26.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "ViewController.h"
#import "CATS.h"
#import "NetworkManager.h"
#import "CollectionViewCell.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,strong) NSMutableArray *catArray;
@property UICollectionViewFlowLayout *defaultLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _catArray = [NSMutableArray new];
    [self setupdefaultLayout];

    self.myCollectionView.collectionViewLayout=self.defaultLayout;
 
    NetworkManager *netWork=[NetworkManager new];
    
    [netWork FetchPhotoURLWithCompletionBlock:^(NSArray *array) {
        
        
        for (NSString* string in array) {
            CATS *cat = [CATS new];
            cat.catURL = string;
            [self.catArray addObject:cat];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.myCollectionView reloadData];
        }];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.catArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CollectionViewCell *cell =[self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"Cellid" forIndexPath:indexPath];
    CATS *cat = self.catArray[indexPath.item];
    
    if (cat.catImages) { // ToDo rename cat.catImages to cat.catImage
        cell.myImageView.image = cat.catImages;
    } else {
        
        NetworkManager *networkManager = [[NetworkManager alloc] init]; // ToDo Make D.R.Y make property on class instanicate in view did load
        
        [networkManager FetchPhotoWithURL:cat.catURL CompletionBlock:^(UIImage *image) {
            cat.catImages = image;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.myImageView.image = image;
            }];
            
        }];
    }
    
    
    
    return cell;
}

-(void)setupdefaultLayout{
    
    self.defaultLayout = [[UICollectionViewFlowLayout alloc]init];
    self.defaultLayout.itemSize = CGSizeMake(150, 250);
    self.defaultLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.defaultLayout.minimumInteritemSpacing=5;
    self.defaultLayout.minimumLineSpacing=10;
    self.defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.defaultLayout.headerReferenceSize = CGSizeMake(200, 0);
    
}

@end
