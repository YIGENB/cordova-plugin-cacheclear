
/********* Cacheclear.m Cordova Plugin Implementation *******/
 
#import <Cordova/CDV.h>
 
@interface Cacheclear : CDVPlugin
{
    // Member variables go here.
}
- (void)getCacheSize:(CDVInvokedUrlCommand *)command;
- (void)deleteFileCache:(CDVInvokedUrlCommand *)command;
 
@end
 
@implementation Cacheclear
 
//默认调用检查缓存
- (void)getCacheSize:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSLog(@"检查缓存");
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@", path); //打印缓存路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        float folderSize = 0.0;
        CDVPluginResult *pluginResult = nil;
        if ([fileManager fileExistsAtPath:path])
        {
            //拿到算有文件的数组
            NSArray *childerFiles = [fileManager subpathsAtPath:path];
            //拿到每个文件的名字,如有有不想清除的文件就在这里判断
            for (NSString *fileName in childerFiles)
            {
                //将路径拼接到一起
                NSString *fullPath = [path stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath:fullPath];
            }
            NSLog(@"%@", [NSString stringWithFormat:@"缓存大小为%.2f,确定要清理缓存吗?", folderSize]);
            NSLog(@"%@", [NSString stringWithFormat:@"%.2f", folderSize]);
            if (folderSize / 1024.0 / 1024.0 / 1024.0 > 1.0)
            {
                float cache = folderSize / 1024.0 / 1024.0 / 1024.0;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%.2fGB", cache]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            else if (folderSize / 1024.0 / 1024.0 > 1.0)
            {
                float cache = folderSize / 1024.0 / 1024.0;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%.2fMB", cache]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            else if (folderSize / 1024.0 > 1.0)
            {
                float cache = folderSize / 1024.0;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%.2fKB", cache]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            else
            {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"0KB"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
        }
        else
        {
            NSLog(@"清理失败");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}
 
//计算单个文件夹的大小
- (float)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
 
//清理缓存
- (void)deleteFileCache:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path])
        {
            NSArray *childerFiles = [fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles)
            {
                //如有需要，加入条件，过滤掉不想删除的文件
                NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
            CDVPluginResult *pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"缓存清理成功"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
        else
        {
            CDVPluginResult *pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"缓存清理失败"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}
 
@end