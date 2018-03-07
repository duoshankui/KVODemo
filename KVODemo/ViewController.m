//
//  ViewController.m
//  KVODemo
//
//  Created by DoubleK on 2018/3/7.
//  Copyright © 2018年 DoubleK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSNumber *kvoNumber;    //被监听属性

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [addBtn setBackgroundColor:[UIColor redColor]];
    [addBtn setTitle:@"Add" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    /*
     KVO 基本原理：
     1.KVO 是基于runtime 机制实现的
     2.当某个类的属性对象第一次被观察时，系统就会在运行期动态的创建该类的一个派生类，在这个派生类中重写基类中的任何被观察属性的setter方法。派生类在被重写的setter方法内实现真正的通知机制。
     3.如果原类为person，那么派生类为NSKVONotifying_Person;
     4.每个类对象中都有一个isa指针指向当前类，当一个类对象第一次被观察时，那么系统会偷偷的把isa指针指向动态生成的派生类，从而再给被监控属性赋值时执行的是该派生类的setter方法。
     5.键值观察通知依赖于NSObject的两个方法：willChangeValueForKey:和didChangeValueForKey:;在一个被观察属性发生改变之前，willChangeValueForKey:一定会被调用，这就会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而observeValueForKeyPath: ofObject: change: context:也会被调用。
     
     */
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self addObserver:self forKeyPath:@"kvoNumber" options:options context:nil];
}

//- (void)willChangeValueForKey:(NSString *)key
//{
//    NSLog(@"willChangeValueForKey: %@",key);
//}
//
//- (void)didChangeValueForKey:(NSString *)key
//{
//    NSLog(@"didChangeValueForKey: %@",key);
//}

#pragma mark --btnAction
- (void)addBtnAction:(UIButton *)btn
{
    int num = [self.kvoNumber intValue];
    num += 1;
    self.kvoNumber = [NSNumber numberWithInt:num];
    
    [btn setTitle:[NSString stringWithFormat:@"Add  %@",self.kvoNumber] forState:UIControlStateNormal];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"kvoNumber"]) {
        
        NSNumber *oldNumber = [change objectForKey:@"old"];
        NSNumber *newNumber = [change objectForKey:@"new"];
        NSLog(@"oldNumber : %@ ----  newNumber : %@",oldNumber,newNumber);
    }
}


//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    if ([keyPath isEqualToString:@"kvoNumber"]) {
//
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
