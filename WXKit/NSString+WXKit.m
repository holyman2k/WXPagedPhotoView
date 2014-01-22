//
//  NSString+WXKit.m
//  WXKit
//
//  Created by Charlie Wu on 23/12/2013.
//  Copyright (c) 2013 Charlie Wu. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import "NSString+WXKit.h"

@implementation NSString (WXKit)

+ (BOOL)isEmptyOrNil:(NSString *)string
{
    return !string || (id)string == [NSNull null] || string.length == 0;
}

+ (BOOL)isEmptyOrNilOrOnlyWhiteSpace:(NSString *)string
{
    NSString *trimed = string.trim;
    
    return [NSString isEmptyOrNil:trimed];
}

- (NSString *)trim
{
    NSCharacterSet *trimCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:trimCharSet];
}

- (CGFloat)heightForFont:(UIFont *)font andWidth:(CGFloat)width
{
    NSDictionary *attributesDictionary = @{NSFontAttributeName: font};
    
    if ([UIDevice currentDevice].systemVersion.floatValue  < 7) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX)].height;
        #pragma clang diagnostic pop
        
    } else {
        return [self boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                       options: NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributesDictionary
                                       context:nil].size.height;
    }
}

- (CGFloat)widthForFont:(UIFont *)font
{
    NSDictionary *attributesDictionary = @{NSFontAttributeName: font};
    
    if ([UIDevice currentDevice].systemVersion.floatValue  < 7) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)].width;
        #pragma clang diagnostic pop
        
    } else {
        return [self boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                  options: NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributesDictionary
                                  context:nil].size.width;
    }
}

- (NSData *)encryptWithKey:(NSString *)key
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];

    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);

    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }

    free(buffer); //free the buffer;
    return nil;
}

+ (NSString *)stringWithEncryptedNSData:(NSData *)data withKey:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [data length];

    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);

    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSString *plainText = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] encoding:NSUTF8StringEncoding];
        return plainText;
    }

    free(buffer); //free the buffer;
    return nil;
}

@end
