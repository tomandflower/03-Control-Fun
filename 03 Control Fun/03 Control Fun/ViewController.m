//
//  ViewController.m
//  03 Control Fun
//
//  Created by tomandhua on 16/3/30.
//  Copyright © 2016年 tomandhua. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UILabel *sliderLabel;
@property (strong, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (strong, nonatomic) IBOutlet UIButton *doSomethingButton;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"kjsjdfksdsfsdfs");
    self.sliderLabel.text = @"50";
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sliderChanged:(UISlider *)sender {
    int progress = lroundf(sender.value);
    self.sliderLabel.text = [NSString stringWithFormat:@"%d", progress];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    BOOL setting = sender.isOn;
    [self.leftSwitch setOn:setting animated:YES];
    [self.rightSwitch setOn:setting animated:YES];
    
}

- (IBAction)toggleControls:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.leftSwitch.hidden = NO;
        self.rightSwitch.hidden = NO;
        self.doSomethingButton.hidden = YES;
    } else {
        self.leftSwitch.hidden = YES;
        self.rightSwitch.hidden = YES;
        self.doSomethingButton.hidden = NO;
    }
}

- (IBAction)buttonPressed:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"Are you sure?"
//                                  delegate:self
//                                  cancelButtonTitle:@"No Way!"
//                             destructiveButtonTitle:@"Yes, I'm sure!"
//                                  otherButtonTitles:nil, nil];
//    [actionSheet showInView:self.view];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"Yes, I,m sure!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"something was done!" message:[NSString stringWithFormat:@"You can breathe easy, %@, everthing went OK.", self.nameField.text] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ddAction = [UIAlertAction actionWithTitle:@"Phew!" style:UIAlertActionStyleCancel handler:nil];
        [alertView addAction:ddAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
        NSLog(@"sure");
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"No Way!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        
        NSLog(@"cancel");
    }];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        NSLog(@"no thing");
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSString *msg = nil;
        
        if ([self.nameField.text length] > 0) {
            msg = [NSString stringWithFormat:@"You can breathe easy, %@, everthing went OK.", self.nameField.text];
        } else {
            msg = @"You can breathe easy, everthing went OK.";
        }
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"something was done!"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"Phew!"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)backgroundTap:(id)sender {
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
}

- (IBAction)getCode:(id)sender {
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);

}

@end
