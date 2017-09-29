//
//  APListSelectionViewController.h
//  MU by Peugeot
//
//  Created by Michael Müller on 06.11.14.
//  Copyright (c) 2014 Michael Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APListSelectionViewController : UIViewController

@property (nonatomic, copy) void (^onSelection)(NSString *value, int index);
@property (nonatomic, strong) NSArray *values;

+ (instancetype) selectionViewController;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated completion:(void(^)(void))completion;

+ (instancetype)initSelectionViewControllerOnViewController:(UIViewController *)ctl;

@end


//// INSTANTIATE SELECTION VIEW
//if(!self.selectionViewController) {
//    self.selectionViewController = [APListSelectionViewController selectionViewController];
//    [self addChildViewController:self.selectionViewController];
//    [self.selectionViewController viewDidLoad];
//}
//
//// ADD SELECTION VIEW
//if(!self.selectionViewController.view.superview) {
//    [self.view addSubview:self.selectionViewController.view];
//    self.selectionViewController.view.frame = self.view.bounds;
//}
//
//// GET VIEWS IN RANGE
//[self.selectionViewController hide:NO completion:nil];
//
//// FILL VALUES
//self.selectionViewController.values = @[@"Mädchen", @"Junge"];
//
//// DISABLE TABLE TO SCROLL
//self.tableView.scrollEnabled = NO;
//
//__block APMyPregnancyViewController *me = self;
//[self.selectionViewController setOnSelection:^(NSString *str, int idx) {
//    [USRD setValue:idx? @"m" : @"w" forKey:PREGNANCY_GENDER];
//    [me updateUI];
//    [me.selectionViewController.view removeFromSuperview];
//}];
//
//[self.selectionViewController show:YES];