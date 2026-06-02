---
title: Getting Started with Hexo
date: 2026-06-01 09:00:00
categories: Technology
tags:
  - Hexo
  - Blog
  - Static Site Generator
---

Welcome to my blog! This post will guide you through the basics of getting started with Hexo.

## What is Hexo?

Hexo is a fast, simple, and powerful blog framework powered by Node.js. It allows you to write blog posts in Markdown and generates a static website that can be hosted on GitHub Pages or any other hosting service.

## Key Features

- **Fast**: Hexo is built for speed. It can generate a website with hundreds of files in seconds.
- **Simple**: With a straightforward configuration, you can have your site up and running quickly.
- **Powerful**: Hexo supports plugins and themes, allowing you to extend its functionality.
- **Free Hosting**: You can host your Hexo blog for free on GitHub Pages.

## Getting Started

To get started with Hexo:

1. Install Node.js and npm
2. Install Hexo CLI: `npm install -g hexo-cli`
3. Create a new blog: `hexo init my-blog`
4. Install dependencies: `cd my-blog && npm install`
5. Start the local server: `hexo server`

Your blog will be available at `http://localhost:4000`

## Writing Posts

To create a new post:

```bash
hexo new post "My New Post"
```

This will create a new markdown file in the `source/_posts` directory where you can write your content.

## Deployment

When you're ready to publish, build and deploy your site:

```bash
hexo clean
hexo generate
hexo deploy
```

Happy blogging!
