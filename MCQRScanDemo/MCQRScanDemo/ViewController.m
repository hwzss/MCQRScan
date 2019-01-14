//
//  ViewController.m
//  MCQRScanDemo
//
//  Created by kaifa on 2019/1/14.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "ViewController.h"

static NSString * const KTableViewCellId = @"KTableViewCellId";

@interface CellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *classStr;

@end

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CellModel *> *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MCQRScan";
    
    [self initializeViews];
    [self initializeViewsData];
    
    [_tableView reloadData];
}

- (void)initializeViews {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 66;
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KTableViewCellId];
    
    self.tableView = tableView;
}

- (void)initializeViewsData {
    CellModel *item0 = ({
        CellModel *item = [[CellModel alloc] init];
        item.title = @"直接使用MCQRScanner";
        item.classStr = @"DemoScanVc";
        item;
    });
    
    CellModel *item1 = ({
        CellModel *item = [[CellModel alloc] init];
        item.title = @"小小的自定义下UI，添加几个SubView";
        item.classStr = @"MCQRScanController";
        item;
    });
    
    self.items = @[item0, item1];
}

#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTableViewCellId forIndexPath:indexPath];
    cell.textLabel.text = _items[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *aVc = [[NSClassFromString(_items[indexPath.row].classStr) alloc] init];
    [self.navigationController pushViewController:aVc animated:YES];
}


@end

@implementation CellModel


@end
