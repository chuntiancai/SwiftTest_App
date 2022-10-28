//
//  LameTool.h
//  SwiftTest_App
//
//  Created by mathew on 2022/10/28.
//  Copyright © 2022 com.mathew. All rights reserved.
//
// 音频文件转码 MP3（由于方法内部多以 C 语言为主，用 Swift 语言写的时候有些问题，此处仍以 OC 文件）

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LameTool : NSObject

+ (NSString *)audioToMP3: (NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete;

+ (NSString *)audioToMP3: (NSString *)sourcePath samplerate:(int)samplerate bitRate:(int)bitRate isDeleteSourchFile:(BOOL)isDelete;
@end

NS_ASSUME_NONNULL_END
