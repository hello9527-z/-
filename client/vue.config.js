const path = require('path');
module.exports = {
    devServer:{
        proxy:{
            '/api':{
                target:'http://localhost:5000'
            }
        }
    },
    // npm run bulid dist文件出口路径
    publicPath:"./",
    outputDir:path.resolve(__dirname,'../app/public'),
    assetsDir:'static'
}
