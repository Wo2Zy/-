//
//  WWCalVuew.m
//  WWCalView
//
//  Created by 王威 on 2017/12/18.
//  Copyright © 2017年 WWin. All rights reserved.
//

#import "WWCalVuew.h"
@interface WWCalVuew()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)double aaa;
@end
@implementation WWCalVuew
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [[[NSBundle mainBundle]loadNibNamed:@"WWCalVuew" owner:self options:nil] lastObject];
        [self addSubview:self.bgView];
    }
    return self;
}
-(void)layoutSubviews{
    self.bgView.frame = self.bounds;
}
- (IBAction)click:(UIButton *)sender {
    NSInteger conut = self.dataArray.count;
    if (conut == 0) {
        conut = 0;
        if (sender.tag == 15) {
            return;
        }else{
            [self.dataArray addObject:@""];
        }
    }else{
        conut = self.dataArray.count - 1;
    }
     NSString *str = self.dataArray[conut];
    if (([str isEqualToString:@"+"] || [str isEqualToString:@"-"] || [str isEqualToString:@"*"] || [str isEqualToString:@"/"]) && sender.tag != 15) {
        if (sender.tag == 10) {
          [self.dataArray addObject:@"0."];
        }else if(sender.tag < 10){
         [self.dataArray addObject:[NSString stringWithFormat:@"%ld",sender.tag]];
        }
    }else{
        if (sender.tag < 11) {
            if (sender.tag == 10) {//点击的是.
                if ([str isEqualToString:@""]==YES) {
                    str = [NSString stringWithFormat:@"0.%@",str];
                    [self.dataArray replaceObjectAtIndex:conut withObject:str];
                }else if([str containsString:@"."]){
                    
                }else{
                    str = [NSString stringWithFormat:@"%@.",str];
                    [self.dataArray replaceObjectAtIndex:conut withObject:str];
                }
            }else{//点击的是0...9
                if (sender.tag == 0) {
                    if ([str isEqualToString:@"0"]) {
                        str = [NSString stringWithFormat:@"%@.%ld",str,sender.tag];
                        [self.dataArray replaceObjectAtIndex:conut withObject:str];
                    }else{
                        str = [NSString stringWithFormat:@"%@0",str];
                        [self.dataArray replaceObjectAtIndex:conut withObject:str];
                    }
                }else{
                    str = [NSString stringWithFormat:@"%@%ld",str,(long)sender.tag];
                    [self.dataArray replaceObjectAtIndex:conut withObject:str];
                }
            }
        }else if (sender.tag >= 11 && sender.tag <= 14){
            if (self.dataArray.count == 0) {
                
            }else if ([str isEqualToString:@""] == YES){
                
            }else{
                if([str isEqualToString:@"0."] == YES){
                    str = @"0";
                    [self.dataArray replaceObjectAtIndex:conut withObject:str];
                }
                switch (sender.tag) {
                    case 11:{
                        [self.dataArray addObject:@"+"];
                    }
                        break;
                    case 12:{
                        [self.dataArray addObject:@"-"];
                    }
                        break;
                    case 13:{
                        [self.dataArray addObject:@"*"];
                    }
                        break;
                    case 14:{
                        [self.dataArray addObject:@"/"];
                    }
                        break;
                    default:
                        break;
                }
            }
        }else{
            if ([str containsString:@"+"] == NO || [str containsString:@"-"] == NO || [str containsString:@"*"] == NO || [str containsString:@"/"] == NO) {
                NSLog(@"%@",str);
                if (str.length == 1) {
                    [self.dataArray removeObjectAtIndex:conut];
                }else if (str.length == 0){
                    
                }else{
                    str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
                    [self.dataArray replaceObjectAtIndex:conut withObject:str];
                }
            }else if (self.dataArray.count == 0){
                
            }else{
                [self.dataArray removeObjectAtIndex:conut];
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            weakSelf.aaa = [obj doubleValue];
        }else{
            if (idx % 2 == 0) {
                if ([[weakSelf.dataArray objectAtIndex:idx - 1] isEqualToString:@"+"]) {
                    weakSelf.aaa += [obj doubleValue];
                }else if ([[weakSelf.dataArray objectAtIndex:idx - 1] isEqualToString:@"-"]){
                    weakSelf.aaa -= [obj doubleValue];
                }else if ([[weakSelf.dataArray objectAtIndex:idx - 1] isEqualToString:@"*"]){
                    weakSelf.aaa -= [weakSelf.dataArray[idx - 2] doubleValue];
                    weakSelf.aaa += ([weakSelf.dataArray[idx - 2] doubleValue] * [obj doubleValue]);
                }else{
                    weakSelf.aaa -= [weakSelf.dataArray[idx - 2] doubleValue];
                    weakSelf.aaa += ([weakSelf.dataArray[idx - 2] doubleValue] / [obj doubleValue]);
                }
            }
        }
        [weakSelf performSelectorOnMainThread:@selector(change) withObject:nil waitUntilDone:YES];
    }];
}
-(void)change{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"love" object:nil userInfo:@{@"question":[self.dataArray componentsJoinedByString:@""],@"answer":self.dataArray.count == 0 ? @"0.00" : [NSString stringWithFormat:@"%.2f",self.aaa]}];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithObjects:@"", nil];
    }
    return _dataArray;
}
@end
