//
//  KIAliPay.m
//  AlipayDemo
//
//  Created by apple on 15/4/9.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIAliPay.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"
#import "DataSigner.h"

@interface KIAliPay ()
@property (nonatomic, strong) NSString *appScheme;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *partner;
@property (nonatomic, strong) NSString *seller;
@property (nonatomic, strong) NSString *notifyURL;
@end

@implementation KIAliPay

+ (KIAliPay *)sharedInstance {
    static KIAliPay *ALI_PAY;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ALI_PAY = [[KIAliPay alloc] init];
    });
    return ALI_PAY;
}

+ (void)setAppScheme:(NSString *)scheme {
    [[KIAliPay sharedInstance] setAppScheme:scheme];
}

+ (void)setPrivateKey:(NSString *)key {
    [[KIAliPay sharedInstance] setPrivateKey:key];
}

+ (void)setPartner:(NSString *)partner {
    [[KIAliPay sharedInstance] setPartner:partner];
}

+ (void)setSeller:(NSString *)seller {
    [[KIAliPay sharedInstance] setSeller:seller];
}

+ (void)setNotifyURL:(NSString *)notifyURL {
    [[KIAliPay sharedInstance] setNotifyURL:notifyURL];
}

+ (void)alipayWithTradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                   itBPay:(NSString *)itBPay
                    block:(KIPayCompletionBlock)block {
    KIAliPay *aliPay = [KIAliPay sharedInstance];
    
    [self alipayWithPartner:aliPay.partner
                     seller:aliPay.seller
                    tradeNO:tradeNO
                productName:productName
         productDescription:productDescription
                     amount:amount
                  notifyURL:aliPay.notifyURL
                    service:@"mobile.securitypay.pay"
                paymentType:@"1"
               inputCharset:@"UTF-8"
                     itBPay:itBPay
                 privateKey:aliPay.privateKey
                  appScheme:aliPay.appScheme
                      block:block];
}

+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                   itBPay:(NSString *)itBPay
                    block:(KIPayCompletionBlock)block {
    
    KIAliPay *aliPay = [KIAliPay sharedInstance];
    
    [self alipayWithPartner:partner
                     seller:seller
                    tradeNO:tradeNO
                productName:productName
         productDescription:productDescription
                     amount:amount
                  notifyURL:notifyURL
                    service:@"mobile.securitypay.pay"
                paymentType:@"1"
               inputCharset:@"UTF-8"
                     itBPay:itBPay
                 privateKey:aliPay.privateKey
                  appScheme:aliPay.appScheme
                      block:block];
}

+ (void)alipayWithPartner:(NSString *)partner
                   seller:(NSString *)seller
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL
                  service:(NSString *)service
              paymentType:(NSString *)paymentType
             inputCharset:(NSString *)inputCharset
                   itBPay:(NSString *)itBPay
               privateKey:(NSString *)privateKey
                appScheme:(NSString *)appScheme //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                    block:(KIPayCompletionBlock)block {
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = amount; //商品价格
    order.notifyURL =  notifyURL; //回调URL
    
    order.service = service;
    order.paymentType = paymentType;
    order.inputCharset = inputCharset;
    order.itBPay = itBPay;
    order.showUrl = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    if (signedString != nil) {
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if (block != nil) {
                block(resultDic);
            }
        }];
    }
}

+ (NSString *)generateTradeNumber {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (NSString *)defaultItBPay {
    return @"30m";
}

@end
