# KKNetworking
A low-level  networking framework for iOS based on AFNetworking3.x.


## KKNetworkConfig类
（存放一些全局通用的参数）
baseUrl 服务器地址
AFSecurityPolicy 安全策略 https认证
requestMethod 请求方式 默认Post
requestTimeoutInterval 超时时间 默认20s
requestHeaderFieldValueDictionary 请求头

可在AppDelegate配置

## KKNetworkRequest类
（主要使用的类）
---------------请求设置---------------
requestUrl 请求地址
requestArgument 请求参数
requestMethod 请求方式 
requestTimeoutInterval 超时时间 
requestHeaderFieldValueDictionary 请求头
---------------返回数据---------------
responseData，responseJSONObject，responseObject，responseString，error
isResponseSerializerTypeHTTP默认返回数据Json解析，可设置为不操作

## KKNetworkManager类
（请求主要发起类）
初始化时读取config的一些配置
在处理request请求时 优先取request的参数处理
没有时取config的默认设置（如请求方式，超时时间，请求头等）
发起请求接受数据进行成功与失败的回调

## KKNetworkTools类
一些用到的方法


在YTKNetwork上进行修改而成 大部分源码来自 [YTKNetwork](https://github.com/yuantiku/YTKNetwork)
供简单的项目使用 可以进行功能扩展
