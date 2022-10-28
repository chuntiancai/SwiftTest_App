//
//  LameTool.m
//  SwiftTest_App
//
//  Created by mathew on 2022/10/28.
//  Copyright © 2022 com.mathew. All rights reserved.
//

#import "LameTool.h"
#import "lame.h"

@implementation LameTool


/// caf转换转换为mp3格式
/// @param sourcePath caf源文件。
/// @param isDelete 是否删除源文件。
+ (NSString *)audioToMP3: (NSString *)sourcePath isDeleteSourchFile:(BOOL)isDelete
{

    // 输入路径
    NSString *inPath = sourcePath;

    // 判断输入路径是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath])
    {
        NSLog(@"文件不存在");
    }

    // 输出路径
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];


    @try {
        int read, write;

        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            size_t size = (size_t)(2 * sizeof(short int));
            read = fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功:");
        if (isDelete) {

            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil)
            {
                NSLog(@"删除源文件成功");
            }

        }
        return outPath;
    }
    
}

/// caf转换为mp3格式
/// @param sourcePath 源文件路径。
/// @param samplerate 采样频率，通常设置为44100。
/// @param bitRate 设置CBR的比特率，只有在CBR模式下才生效。
/// @param isDelete 是否删除源文件。
+ (NSString *)audioToMP3: (NSString *)sourcePath samplerate:(int)samplerate bitRate:(int)bitRate isDeleteSourchFile:(BOOL)isDelete {
    
    // 输入路径
    NSString *inPath = sourcePath;
    // 判断输入路径是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath]) {
        NSLog(@"文件不存在");
    }
    // 输出路径
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
    @try {
        int read, write;
        
        // 被转换的音频文件位置
        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");
        // skip file header 跳过 PCM header 能保证录音的开头没有噪音
        fseek(pcm, 4*1024, SEEK_CUR);
        // 输出生成的Mp3文件位置（这里注意打开文件的方式wb 只写方式打开或新建一个二进制文件，只允许写数据；wb+ 读写方式打开或建立一个二进制文件，允许读和写
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb+");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();

        // 设置1为单通道，默认为2双通道（录音时是双通道）
//        lame_set_num_channels(lame,2);
        // 设置最终mp3编码输出的声道模式，如果不设置则和输入声道数一样。参数是枚举，STEREO代表双声道，MONO代表单声道
//        lame_set_mode(lame,STEREO);

        // 设置被输入编码器的原始数据的采样率，单位是HZ 通常设置成44100 44.1k
        lame_set_in_samplerate(lame, samplerate);

        // 设置比特率控制模式，默认是CBR，但是通常我们都会设置VBR。参数是枚举，vbr_off代表CBR，vbr_abr代表ABR（因为ABR不常见，所以本文不对ABR做讲解）vbr_mtrh代表VBR，vbr_default = vbr_mtrh 代表 VBR
//        lame_set_VBR(lame, vbr_default);
        // 设置VBR的比特率，只有在VBR模式下才生效
//        lame_set_VBR_mean_bitrate_kbps(lame, 16);

        // CBR 固定比特率；ABR 平均比特率
        // VBR 动态比特率，以质量为前提兼顾文件大小的方式

        // 设置 CBR 模式和比特率
        lame_set_VBR(lame, vbr_off);
        // 设置CBR的比特率，只有在CBR模式下才生效
        lame_set_brate(lame, bitRate);
        // 根据上面设置好的参数建立编码器
        lame_init_params(lame);
        
        do {
            size_t size = (size_t)(2 * sizeof(short int));
            // fread是一个函数。从一个文件流中读数据，最多读取count个元素，每个元素size字节，如果调用成功返回实际读取到的元素个数，如果不成功或读到文件末尾返回 0。
            read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0) {
                // 刷新编码器缓冲，获取残留在编码器缓冲里的数据。这部分数据也需要写入mp3文件
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                // 将PCM数据送入编码器，获取编码出的mp3数据。这些数据写入文件就是mp3文件
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            // 写入文件
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        // 将VBR/INFO tags封装到一个MP3 Frame中，写到文件开头。如果输出流没有办法回溯，那么必须在第3步设置lame_set_bWriteVbrTag(gfp,0)，这一步调用lame_mp3_tags_fid(lame_global_flags *,FILE* fid)将fid参数＝NULL。这样的话那个开头的信息帧（MP3 FRAME）的所有字节都是0
        // 在lame_close之前一定要调用lame_mp3_tags_fid()这个方法，不然时间计算不准确，此处是针对 VBR 模式
        // 编码的MP3会预留 VBR tag的空间，如果不插入，会影响计算时间。非VBR模式也会空出 VBR tag。这也是前面文件读写那设置‘wb+‘的原因。 进源码看吧，有详细注释！
//        lame_mp3_tags_fid(lame, mp3);
        
        // 销毁编码器，释放资源
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功:");
        if (isDelete) {
            
            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil) {
                NSLog(@"删除源文件成功");
            }
        }
        return outPath;
    }
}

/// CBR 模式，固定比特率
+ (NSString *)audioCBRToMP3: (NSString *)sourcePath samplerate:(int)samplerate bitRate:(int)bitRate isDeleteSourchFile:(BOOL)isDelete {
    
    NSString *inPath = sourcePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath]) {
        NSLog(@"文件不存在");
    }
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame, 2);
        lame_set_mode(lame, STEREO);
        lame_set_in_samplerate(lame, samplerate);
        lame_set_VBR(lame, vbr_off);
        lame_set_brate(lame, bitRate);
        lame_init_params(lame);
        
        do {
            size_t size = (size_t)(2 * sizeof(short int));
            read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功 ------------------");
        if (isDelete) {
            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil) {
                NSLog(@"删除源文件成功");
            }
        }
        return outPath;
    }
}

/// VBR 模式，动态比特率
+ (NSString *)audioVBRToMP3: (NSString *)sourcePath samplerate:(int)samplerate bitRate:(int)bitRate isDeleteSourchFile:(BOOL)isDelete {
    
    NSString *inPath = sourcePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath]) {
        NSLog(@"文件不存在");
    }
    NSString *outPath = [[sourcePath stringByDeletingPathExtension] stringByAppendingString:@".mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([inPath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([outPath cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame, 2);
        lame_set_mode(lame, STEREO);
        lame_set_in_samplerate(lame, samplerate);
        lame_set_VBR(lame, vbr_default);
        lame_set_VBR_mean_bitrate_kbps(lame, bitRate);
        lame_set_VBR_max_bitrate_kbps(lame, bitRate * 2);
        lame_set_VBR_min_bitrate_kbps(lame, bitRate);
        lame_init_params(lame);
        
        do {
            size_t size = (size_t)(2 * sizeof(short int));
            read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_mp3_tags_fid(lame, mp3);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功 ------------------");
        if (isDelete) {
            NSError *error;
            [fm removeItemAtPath:sourcePath error:&error];
            if (error == nil) {
                NSLog(@"删除源文件成功");
            }
        }
        return outPath;
    }
}


@end


