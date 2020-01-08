var exec = require('cordova/exec');
 
var myAPI = {}
 
myAPI.deleteFileCache = function(success, error) {
  exec(success, error, "Cacheclear", "deleteFileCache");
};
//获取缓存大小
myAPI.getCacheSize = function( success, error) {
  exec(success, error, "Cacheclear", "getCacheSize");
};
 
module.exports = myAPI;