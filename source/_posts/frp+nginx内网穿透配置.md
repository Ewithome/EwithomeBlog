---
title: frp + Nginx 内网穿透配置
date: 2026-06-25 10:00:00
categories: 运维
tags:
  - frp
  - nginx
  - 内网穿透
---

# frp 内网穿透配置（v0.55.1 版本）

> 参考原文：[frp 内网穿透配置（v0.55.1 版本）](https://juejin.cn/post/7346072037674418187)

frp 是一个专注于内网穿透的高性能反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可将 NAT 或防火墙后面的本地服务器暴露到公网。

> **注意**：从 v0.52.0 版本开始，配置文件由 `frps.ini` / `frpc.ini` 改成了 `frps.toml` / `frpc.toml`。

- **GitHub 地址**：https://github.com/fatedier/frp
- 下载后若杀毒软件报毒，可加入白名单处理

## 1、服务端配置

**环境要求**：公网 IP 服务器 + 域名  
**frp 版本**：v0.55.1

### 1.1 下载软件

```bash
# 方式1：本地直接下载后上传到服务器

# 方式2：wget 命令
wget https://github.com/fatedier/frp/releases/download/v0.55.1/frp_0.55.1_linux_amd64.tar.gz
```

### 1.2 配置

解压并查看目录：

```bash
# 解压
tar -zxvf frp_0.55.1_linux_amd64.tar.gz

# 进入目录
cd frp_0.55.1_linux_amd64
ls -ll
```

文件说明：

| 文件 | 说明 |
| --- | --- |
| `frps` | 服务端可执行文件 |
| `frps.toml` | 服务端配置文件 |
| `frpc` | 客户端可执行文件 |
| `frpc.toml` | 客户端配置文件 |

#### 1.2.1 修改配置

编辑 `frps.toml`：

```toml
# 服务端口
bindPort = 7000

# 授权码，请改成更复杂的，客户端会用到
auth.token = "token123456"

# 服务端通过此端口监听和接收公网用户的 http 请求
vhostHTTPPort = 7000

# dashboard 配置
webServer.addr = "0.0.0.0"
webServer.port = 7001
# dashboard 用户名密码，可选，默认为空
webServer.user = "admin"
webServer.password = "admin"
```

#### 1.2.2 防火墙开启端口

开启 **7000**、**7001** 端口。

#### 1.2.3 启动

```bash
# 前台启动
./frps -c ./frps.toml

# 后台启动
./frps -c ./frps.toml &
```

浏览器访问 `http://公网IP:7001`，输入账号密码即可进入 dashboard。至此服务端配置完成。

#### 1.2.4 加入 systemd 服务（可选）

在 Linux 系统下，使用 systemd 可以方便地控制 frps 的启动、停止、后台运行以及开机自启动。

**操作步骤：**

1. **安装 systemd**（若尚未安装）

```bash
# CentOS/RHEL
yum install systemd

# Debian/Ubuntu
apt install systemd
```

2. **创建 frps.service 文件**

```bash
sudo vim /etc/systemd/system/frps.service
```

写入内容：

```ini
[Unit]
# 服务名称，可自定义
Description = frp server
After = network.target syslog.target
Wants = network.target

[Service]
Type = simple
# 启动 frps 的命令，需修改为实际安装路径
ExecStart = /path/to/frps -c /path/to/frps.toml

[Install]
WantedBy = multi-user.target
```

3. **使用 systemd 管理 frps 服务**

```bash
# 启动 frp
sudo systemctl start frps

# 停止 frp
sudo systemctl stop frps

# 重启 frp
sudo systemctl restart frps

# 查看 frp 状态
sudo systemctl status frps
```

4. **设置开机自启动**

```bash
sudo systemctl enable frps
```

## 2、Nginx 配置

### 2.1 域名解析

在域名服务商处添加解析记录：

- `frp.xxx.cn` — 管理面板
- `*.frp.xxx.cn` — 泛域名，用于各子服务（三级域名可自定义）

### 2.2 nginx 配置文件增加如下配置

```nginx
server {
    listen       80;
    listen  [::]:80;
    server_name *.frp.xxx.cn;

    location / {
        proxy_set_header Host $host;
        # frp 监听客户端 http 请求
        proxy_pass http://公网IP:7000;
    }
}

server {
    listen       80;
    listen  [::]:80;
    server_name frp.xxx.cn;

    location / {
        proxy_set_header Host $host;
        # 管理面板
        proxy_pass http://公网IP:7001;
    }
}
```

## 3、客户端配置

以 **Windows 客户端**为例，frp 版本：**v0.55.1**

### 3.1 下载软件

直接下载：

```
https://github.com/fatedier/frp/releases/download/v0.55.1/frp_0.55.1_windows_amd64.zip
```

### 3.2 配置

解压 `frp_0.55.1_windows_amd64.zip`。

#### 3.2.1 修改配置

编辑 `frpc.toml`：

```toml
# 此配置不可更改
serverAddr = "公网ip"
serverPort = 7000

# 授权码和服务端一致
auth.token = "token123456"

# lee 改成你自定义的名字，用来区分用户
user = "lee"

# 代理配置①
[[proxies]]
name = "web2"                              # 改成自定义的项目名
type = "http"
localPort = 1668                           # 改成想代理的端口号
customDomains = ["web2.frp.xxx.cn"]        # 只改三级域名，*.frp.xxx.cn 中的 * 自定义

# 代理配置②（可按需启用）
# [[proxies]]
# name = "web3"
# type = "http"
# localPort = 1669
# customDomains = ["web3.frp.xxx.cn"]
```

#### 3.2.2 启动命令

Windows 下启动：

```powershell
.\frpc.exe -c .\frpc.toml
```

出现 `start proxy success` 说明配置成功。

#### 3.2.3 访问 dashboard 页面

在服务端 dashboard 中可以看到 web 代理已成功注册。

#### 3.2.4 浏览器访问代理接口

浏览器访问 `http://web2.frp.xxx.cn`（对应 `customDomains` 中配置的域名），即可访问内网服务。

## 参考文档

- 官方文档：https://gofrp.org/zh-cn/docs/
