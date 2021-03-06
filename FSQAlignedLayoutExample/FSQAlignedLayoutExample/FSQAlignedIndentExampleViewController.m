//
//  FSQAlignedViewController.m
//  FSQAlignedLayoutExample
//
//  Created by Brian Dorfman on 5/13/14.
//  Copyright (c) 2014 Foursquare. All rights reserved.
//

#import "FSQAlignedIndentExampleViewController.h"

#define kMainFont [UIFont systemFontOfSize:14]

@interface FSQExampleSectionData : NSObject
@property (nonatomic) FSQCollectionViewHorizontalAlignment hAlignment;
@property (nonatomic) NSArray *cellData;
@end

@implementation FSQExampleSectionData
@end

@interface FSQExampleCellData : NSObject
@property (nonatomic) NSString *text;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) BOOL startIndent;
@end

@implementation FSQExampleCellData
@end

@interface FSQExampleCell : UICollectionViewCell
@property (nonatomic) UILabel *label;
@end

@implementation FSQExampleCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        label.backgroundColor = [UIColor clearColor];
        label.font = kMainFont;
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

@end

@interface FSQAlignedIndentExampleViewController ()
@property (nonatomic) NSArray *sectionData;
@end

@implementation FSQAlignedIndentExampleViewController

- (id)init
{
    FSQCollectionViewAlignedLayout *alignedLayout = [FSQCollectionViewAlignedLayout new];
    self = [super initWithCollectionViewLayout:alignedLayout];
    
    if (self) {
        // Custom initialization
        _sectionData = [self generateExampleData];
        self.tabBarItem.title = @"Indent & Spacing";
        self.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -20);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[FSQExampleCell class] forCellWithReuseIdentifier:@"cell"];
    
    CGRect frame = self.collectionView.frame;
    frame.origin.y += 20;
    self.collectionView.frame = frame;
}

- (FSQCollectionViewAlignedLayoutCellAttributes *)collectionView:(UICollectionView *)collectionView 
                                                          layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout 
                                    attributesForCellAtIndexPath:(NSIndexPath *)indexPath {
    FSQExampleCellData *cellData = [(FSQExampleSectionData *)self.sectionData[indexPath.section] cellData][indexPath.item];
    
    return [FSQCollectionViewAlignedLayoutCellAttributes withInsets:UIEdgeInsetsZero 
                                                    shouldBeginLine:NO 
                                                      shouldEndLine:(cellData.text ? YES: NO) 
                                               startLineIndentation:cellData.startIndent];
}

- (FSQCollectionViewAlignedLayoutSectionAttributes *)collectionView:(UICollectionView *)collectionView 
                                                             layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout 
                                        attributesForSectionAtIndex:(NSInteger)sectionIndex {
    FSQExampleSectionData *sectionData = self.sectionData[sectionIndex];
    
    return [FSQCollectionViewAlignedLayoutSectionAttributes withHorizontalAlignment:sectionData.hAlignment 
                                                                  verticalAlignment:FSQCollectionViewVerticalAlignmentTop];
}

- (CGSize)collectionView:(UICollectionView *)collectionView 
                  layout:(FSQCollectionViewAlignedLayout *)collectionViewLayout 
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath 
      remainingLineSpace:(CGFloat)remainingLineSpace {
    FSQExampleCellData *cellData = [(FSQExampleSectionData *)self.sectionData[indexPath.section] cellData][indexPath.item];
    if (cellData.text) {
        CGSize size = CGRectIntegral([cellData.text boundingRectWithSize:CGSizeMake(remainingLineSpace, CGFLOAT_MAX)
                                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                                              attributes:@{ NSFontAttributeName: kMainFont } 
                                                                 context:nil]).size;
        size.width = MIN(remainingLineSpace, size.width);
        return size;
    }
    else {
        return CGSizeMake(25, 25);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView 
     numberOfItemsInSection:(NSInteger)section {
    return [(FSQExampleSectionData *)self.sectionData[section] cellData].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView 
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSQExampleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    FSQExampleCellData *cellData = [(FSQExampleSectionData *)self.sectionData[indexPath.section] cellData][indexPath.item];
    cell.label.text = cellData.text;
    cell.backgroundColor = cellData.backgroundColor;
    
    return cell;
}

- (NSArray *)generateExampleData {
    // First section
    FSQExampleSectionData *sectionOne = [FSQExampleSectionData new];
    sectionOne.hAlignment = FSQCollectionViewHorizontalAlignmentCenter;
    
    FSQExampleCellData *sectionOneCellOne = [FSQExampleCellData new];
    sectionOneCellOne.text = @"Tuesday, June 2nd";
    sectionOne.cellData = @[sectionOneCellOne];
    
    // Second section
    FSQExampleSectionData *sectionTwo = [FSQExampleSectionData new];
    sectionTwo.hAlignment = FSQCollectionViewHorizontalAlignmentLeft;
    
    FSQExampleCellData *sectionTwoAvatarCell = [FSQExampleCellData new];
    sectionTwoAvatarCell.backgroundColor = [UIColor redColor];
    
    NSMutableArray *sectionTwoCells = [NSMutableArray arrayWithObject:sectionTwoAvatarCell];
    
    for (NSString *string in @[@"I must not fear.",
                               @"Fear is the mind-killer.",
                               @"Fear is the little-death that brings total obliteration."]) {
        FSQExampleCellData *cell = [FSQExampleCellData new];
        cell.text = string;
        cell.backgroundColor = [UIColor cyanColor];
        [sectionTwoCells addObject:cell];
    }
    
    [(FSQExampleCellData *)[sectionTwoCells objectAtIndex:1] setStartIndent:YES];
    sectionTwo.cellData = sectionTwoCells;
    
    
    // Third Section
    FSQExampleSectionData *sectionThree = [FSQExampleSectionData new];
    sectionThree.hAlignment = FSQCollectionViewHorizontalAlignmentLeft;
    
    FSQExampleCellData *sectionThreeAvatarCell = [FSQExampleCellData new];
    sectionThreeAvatarCell.backgroundColor = [UIColor blueColor];
    
    FSQExampleCellData *sectionThreeTextCell = [FSQExampleCellData new];
    sectionThreeTextCell.text = @"I will face my fear."
    @"I will permit it to pass over me and through me."
    @"And when it has gone past I will turn the inner eye to see its path."
    @"Where the fear has gone there will be nothing....only I will remain";
    sectionThreeTextCell.backgroundColor = [UIColor greenColor];
    
    sectionThree.cellData = @[sectionThreeAvatarCell, sectionThreeTextCell];
    
    
    return @[sectionOne, sectionTwo, sectionThree];
}
@end
