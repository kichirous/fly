# xray4Fly.io

## 概述
通过 GitHub Actions 自动在 [Fly.io](https://fly.io/) 上部署 [xray](https://xtls.github.io/)

## 配置部署
1. 先到 [Fly.io](https://fly.io/) 注册账号
2. GitHub Actions 增加`FLY_API_TOKEN`、`APP_NAME`和`UUID`三个安全字段
* FLY_API_TOKEN - Fly API 接口 Token 值，可访问 <https://web.fly.io/user/personal_access_tokens> 或在本地执行`flyctl auth token`查看
* APP_NAME - 应用名称，注意此名称全局唯一
* UUID - 供用户连接的 UUID，可通过 <http://www.uuid.online/> 或 <https://www.uuidgenerator.net/> 生成
3. 推送代码即可触发部署，另外已设置每月一号四点（UTC）自动部署

## 客户端连接
* 协议（protocol） - vmess,vless
* 地址（address） - [APP_NAME].fly.dev
* 端口（port） - 443
* 用户ID（id） - [UUID]
* 额外ID（alterId） - 0 
* 传输协议（network） - ws
* 底层传输安全（tls) - tls
