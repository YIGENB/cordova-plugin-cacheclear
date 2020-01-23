# 快速引用
cordova plugin add https://github.com/YIGENB/cordova-plugin-cacheclear

**获取缓存**
cordova.plugins.Cacheclear.getCacheSize(function(res){
    console.log("获取成功")
},
function(res){
    console.log("获取失败")
}
)

**删除缓存**
cordova.plugins.Cacheclear.deleteFileCache (function(res){
    console.log("成功")
},
function(res){
    console.log("失败")
}
)
