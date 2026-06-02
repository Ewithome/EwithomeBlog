# Ewithome Blog

基于 [Hexo](https://hexo.io/) 与 [FlatPaper](https://github.com/Homulilly/hexo-theme-flatpaper) 的个人博客。线上地址：<https://ewithome.github.io>

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

主题文档：[FlatPaper 配置说明](https://github.com/Homulilly/hexo-theme-flatpaper/blob/main/docs/zh/configuration.md)

## 发布到 GitHub Pages

本项目采用 **双仓库** 方式（源码与站点分离）：

| 仓库 | 作用 |
|------|------|
| 源码仓库（本仓库） | 存放 Hexo 源码，推送到 GitHub |
| `Ewithome/Ewithome.github.io` | 仅存放构建后的静态页，分支 `gh-pages` |

### 第一次部署前

1. 在 GitHub 创建 **`Ewithome.github.io`** 仓库（若尚未创建）。
2. 确认 `_config.yml` 中 `url` 为 `https://ewithome.github.io`。
3. **配置 GitHub Actions 自动发布**（推荐，避免本机连不上 `github.com:443`）：

在 **`EwithomeBlog`** 仓库 → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**：

| Name | 值 |
|------|-----|
| `DEPLOY_KEY` | 部署用 SSH 私钥全文（见下） |

生成密钥（PowerShell，在项目外任意目录执行）：

```powershell
ssh-keygen -t ed25519 -C "hexo-deploy" -f deploy_key -N '""'
```

- 把 **`deploy_key.pub`** 内容添加到 **`Ewithome.github.io`** → **Settings** → **Deploy keys** → **Add deploy key**，勾选 **Allow write access**。
- 把 **`deploy_key`**（无私钥后缀的文件）全文复制到 Secret **`DEPLOY_KEY`**。

4. 将 `.github/workflows/deploy.yml` 随源码推送到 `EwithomeBlog` 的 `main` 分支。

### 日常发布流程（推荐）

**双击 `publish.bat`**：本地构建 → `git push` 到 `EwithomeBlog` → **GitHub Actions 在云端** 构建并推送到 `gh-pages`。

打开 [Actions 页面](https://github.com/Ewithome/EwithomeBlog/actions)，等任务变绿后访问 <https://ewithome.github.io>（约 2～5 分钟）。

本机网络能直连 GitHub 时，也可用 **`publish-local.bat`**（走 `hexo deploy`，不经过 Actions）。

### 本机无法连接 GitHub 时

报错 `Failed to connect to github.com port 443` / `Timed out` 表示本机访问 GitHub 受限，**不要用 `publish-local.bat`**，请：

1. 使用 **`publish.bat`** + 上述 **GitHub Actions**（只需能 push 到 `EwithomeBlog`，通常比直连 Pages 仓库更稳定）；或
2. 开 VPN / 代理后再 push。Git 代理示例（端口按你的工具修改）：

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:7890
```

### GitHub Pages 设置

在 **`Ewithome.github.io`** 仓库中：

1. **Settings** → **Pages**
2. **Source** 选择 **Deploy from a branch**
3. **Branch** 选 **`gh-pages`**，目录 **`/ (root)`**
4. 保存后等待几分钟，访问 <https://ewithome.github.io>

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

- [Hexo 文档](https://hexo.io/docs/)
- [FlatPaper 主题](https://github.com/Homulilly/hexo-theme-flatpaper)
- [FlatPaper Demo](https://flatpaper.nep.me/)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
