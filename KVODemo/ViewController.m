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
     
     
     KVO深入原理：
     1.Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为：?NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter?方法，setter?方法会负责在调用原?setter?方法之前和之后，通知所有观察对象属性值的更改情况。
     2.NSKVONotifying_A类剖析：在这个过程中，被观察对象的isa指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类NSKVONotifying_A类，来实现当前类属性值改变的监听。
     3.所以当我们从应用层的角度看来，完全没有意识到有新类的出现，这是系统‘隐藏’了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为NSKVONotifying_A的类()，就会发现系统运行到注册KVO的那段代码时程序会崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向了这个中间类。
     4.isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。）?因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
     5.子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法： 被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath?的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath?的属性值已经变更；之后，?observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter?方法这种继承方式的注入是在运行时而不是编译时实现的。
     
     （KVO原理图： https://upload-images.jianshu.io/upload_images/1829339-77757288cc139f44.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700）
     
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
