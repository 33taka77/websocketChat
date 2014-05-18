//
//  ViewController.m
//  WebSocketChat
//
//  Created by 相澤 隆志 on 2014/05/17.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <SRWebSocketDelegate>
{
    SRWebSocket* _socket;
    BOOL _isConnected;
}
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UITextField *address;
- (IBAction)connectButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
- (IBAction)sendButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;


@end

@implementation ViewController

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
     [webSocket send:[NSString stringWithFormat:@"%@:\n", _address.text]];
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"didReceiveMessage: %@", [message description]);
    _messageTextView.text = [message description]  ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _isConnected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectButtonClicked:(id)sender {
    if( _isConnected == NO ){
        _isConnected = YES;
        [_connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat: @"ws://%@:8080/", _address.text]];
        _socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url]];
        _socket.delegate = self;
        [_socket open];
    }else{
        _isConnected = NO;
        [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [_socket close];
    }
}
- (IBAction)sendButtonClicked:(id)sender {
    [_socket send:[NSString stringWithFormat:@"%@%@:%@\n", _messageTextView.text, _nameField.text,_messageTextField.text]];
}
@end
