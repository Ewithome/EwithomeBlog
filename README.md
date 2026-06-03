# Ewithome Blog

Ewithome 个人博客。线上地址：<https://ewithome.github.io>

## 环境要求

- [Node.js](https://nodejs.org/) 18 或更高版本
- [pnpm](https://pnpm.io/)（推荐）或 npm
- [Git](https://git-scm.com/)

## 快速开始

```bash
# 安装依赖
pnpm install

# 本地预览（默认 http://localhost:4001）
pnpm run server

# 生成静态站点到 public/
pnpm run build
```

## 项目结构

```
EwithomeBlog/
├── source/                 # 站点内容（你要改的主要在这里）
│   ├── _posts/             # 博客文章（Markdown）
│   ├── _data/              # 数据文件（如友链 links.yml）
│   ├── about/              # 关于页
│   ├── links/              # 友链页
│   └── images/             # 图片资源（需自行创建）
├── themes/flatpaper/       # FlatPaper 主题（一般不要改）
├── scaffolds/              # 新建文章/页面的模板
├── _config.yml             # Hexo 站点配置（标题、URL、部署等）
├── _config.flatpaper.yml   # 主题配置（菜单、侧栏、欢迎区等）
├── package.json
└── README.md               # 本说明文档
```

以下内容**不要提交到 Git**（已在 `.gitignore` 中）：

- `node_modules/` — 依赖包
- `public/` — 构建产物
- `db.json` — Hexo 本地缓存

## 写文章：Markdown 放哪里？

**所有博文放在 `source/_posts/`**，文件名为英文或拼音，例如 `my-first-post.md`。

```bash
# 用 Hexo 命令新建（推荐）
pnpm exec hexo new "文章标题"
```

或在 `source/_posts/` 下手动创建 `.md` 文件，头部示例：

```yaml
---
title: 文章标题
date: 2026-06-02 10:00:00
categories: 技术
tags:
  - Hexo
  - 博客
cover: /images/cover.jpg    # 可选：首页/轮播封面
---

正文使用 Markdown 书写。

<!-- more -->               # 可选：首页摘要在此截断
```

| 路径 | 用途 |
|------|------|
| `source/_posts/*.md` | 博客文章 |
| `source/about/index.md` | 关于页 |
| `source/links/index.md` | 友链页（需 `type: links`） |
| `source/_data/links.yml` | 友链卡片数据 |
| `source/images/` | 图片（文中引用 `/images/xxx.jpg`） |

## 常用配置

### 站点信息 — `_config.yml`

- `title`、`subtitle`、`description`、`author`：站点标题与简介
- `url`：线上地址，须与 GitHub Pages 一致（当前为 `https://ewithome.github.io`）
- `language`：语言（当前 `zh-CN`）
- `feed`：RSS（已启用 `atom.xml`）
- `deploy`：发布到 GitHub Pages 的目标仓库

### 主题外观 — `_config.flatpaper.yml`

- `menu`：顶部导航
- `profile`：侧栏作者信息与社交链接
- `welcome`：首页欢迎卡片文案
- `featured`：首页置顶轮播（填文章 slug，如 `hello-world`）
- `color`：默认主题色（`green` / `pink` / `blue` 等）

> 不要直接改 `themes/flatpaper/_config.yml`，升级主题时会被覆盖；请只改根目录的 `_config.flatpaper.yml`。

## 发布到 GitHub Pages

采用 **双仓库**，线上网站只用 **`main` 分支**（不再使用 `gh-pages`）：

| 仓库 | 分支 | 内容 |
|------|------|------|
| **EwithomeBlog** | `main` | Hexo 源码（文章、配置） |
| **Ewithome.github.io** | `main` | 构建后的网站（`index.html` 等） |

### GitHub Pages 设置（只需做一次）

在 **`Ewithome.github.io`** → **Settings** → **Pages**：

- **Source**：Deploy from a branch  
- **Branch**：**`main`**，目录 **`/ (root)`**  
- 若之前选过 `gh-pages`，请改成 **`main`** 并保存  

在 **`EwithomeBlog`** → **Settings** → **Pages**：建议 **关闭** 或不要启用（避免截图里那种 `pages build and deployment` 把 README 当网站发布）。

### 日常发布

**双击 `publish.bat`**，会自动：

1. 构建站点  
2. `hexo deploy` 推送到 **Ewithome.github.io** 的 **`main`**  
3. 备份源码到 **EwithomeBlog**  
4. 用浏览器打开 <https://ewithome.github.io>  

本地预览（改文章时）：`pnpm run server` → http://localhost:4001

### 本机 deploy 失败时的备用方案

若 `hexo deploy` 因网络超时失败，`publish.bat` 会改推源码到 **EwithomeBlog**，由 [GitHub Actions](https://github.com/Ewithome/EwithomeBlog/actions) 部署到 **Ewithome.github.io** 的 **`main`**。

需配置 **`DEPLOY_KEY`** Secret（`EwithomeBlog`）+ **Deploy key**（`Ewithome.github.io`，勾选 write）。详见下方。

<details>
<summary>配置 DEPLOY_KEY（备用 Actions 用）</summary>

```powershell
ssh-keygen -t ed25519 -C "hexo-deploy" -f deploy_key -N '""'
```

- `deploy_key.pub` → **Ewithome.github.io** → Deploy keys（Allow write access）  
- `deploy_key` 全文 → **EwithomeBlog** → Secrets → `DEPLOY_KEY`  

</details>

### 本机无法连接 GitHub 时

报错 `Failed to connect to github.com port 443` 表示本机访问不了 GitHub，**不是脚本问题**。

1. 打开 **VPN / Clash / v2ray** 等代理  
2. 复制 `proxy.local.bat.example` 为 **`proxy.local.bat`**，把端口改成你的代理端口（常见 `7890`、`10809`）  
3. 再运行 **`publish.bat`**

或手动设置（端口按实际修改）：

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy http://127.0.0.1:7890
```

**暂时无法上传时**：双击 **`preview.bat`** 在本地 http://localhost:4001 预览；`publish.bat` 失败时也会自动尝试打开本地预览。

### 上传源码到 GitHub（本仓库）

```bash
git init
git add .
git commit -m "Initial commit: Ewithome Blog"
git remote add origin https://github.com/Ewithome/EwithomeBlog.git
git branch -M main
git push -u origin main
```

仓库名可按你的实际命名修改；**Pages 域名只由 `Ewithome.github.io` 仓库决定**。

## 常用命令

| 命令 | 说明 |
|------|------|
| `pnpm run server` | 本地开发服务器 |
| `pnpm run build` | 生成静态文件到 `public/` |
| `pnpm run clean` | 清除缓存与 `public/` |
| `pnpm run deploy` | 构建并发布到 GitHub Pages |
| `pnpm exec hexo new "标题"` | 新建文章 |
| `pnpm exec hexo new page 页面名` | 新建独立页面 |

## 常见问题

**端口被占用**

修改 `_config.yml` 中 `server.port`（当前为 `4001`），或结束占用端口的进程。

**部署失败 / 权限错误**

- 检查 `deploy.repo` 地址是否正确
- 使用 [Personal Access Token](https://github.com/settings/tokens) 或 SSH 配置推送权限

**修改配置后页面没变化**

```bash
pnpm run clean
pnpm run build
```

**主题更新**

```bash
cd themes/flatpaper
git pull   # 若主题目录仍通过 git 管理；或直接重新 clone 覆盖后保留 _config.flatpaper.yml
```

## 参考链接

- [GitHub](https://github.com/Ewithome)
- [wise-map](https://www.npmjs.com/package/wise-map)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
