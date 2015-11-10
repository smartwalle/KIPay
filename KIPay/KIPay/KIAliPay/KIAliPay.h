//
//  KIAliPay.h
//  AlipayDemo
//
//  Created by apple on 15/4/9.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIPayDefine.h"

@interface KIAliPay : NSObject

//appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
+ (void)setAppScheme:(NSString *)scheme;

//private_key:商户方的私钥,pkcs8 格式。
+ (void)setPrivateKey:(NSString *)key;

+ (void)setPartner:(NSString *)partner;

+ (void)setSeller:(NSString *)seller;

+ (void)setNotifyURL:(NSString *)notifyURL;


+ (void)alipayWithTradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                   itBPay:(NSString *)itBPay
                    block:(KIPayCompletionBlock)block;

/**
 *  @param partner            合作者身份ID
 *  @param seller             卖家支付宝账号
 *  @param tradeNO            商户网站唯一订单号
 *  @param productName        商品名称
 *  @param productDescription 商品详情
 *  @param amount             总金额
 *  @param notifyURL          服务器异步通知页面路径
 *  @param itBPay             未付款交易的超时时间
 */
+ (void)alipayWithPartner:(NSString *)partner //合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
                   seller:(NSString *)seller //支付宝收款账号,手机号码或邮箱格式。
                  tradeNO:(NSString *)tradeNO
              productName:(NSString *)productName
       productDescription:(NSString *)productDescription
                   amount:(NSString *)amount
                notifyURL:(NSString *)notifyURL //支付宝服务器主动通知商户 网站里指定的页面 http 路径。
                   itBPay:(NSString *)itBPay
                    block:(KIPayCompletionBlock)block;

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
                appScheme:(NSString *)appScheme //应用注册scheme,在xxx-Info.plist定义URL types
                    block:(KIPayCompletionBlock)block;

//生成订单号码
+ (NSString *)generateTradeNumber;

+ (NSString *)defaultItBPay;

@end

/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
 */
