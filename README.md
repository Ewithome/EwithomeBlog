# Ewithome Blog

Welcome to my Hexo blog hosted on GitHub Pages!

## About

This is a blog built with [Hexo](https://hexo.io/) using the [NexT](https://theme-next.js.org/) theme. It contains articles about web development, technology, and various other topics.

## Quick Start

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Ewithome/Ewithome.github.io.git
cd Ewithome.github.io
```

2. Install dependencies:
```bash
npm install
```

### Running Locally

To preview the blog locally:

```bash
hexo server
```

The blog will be available at `http://localhost:4000`

### Creating New Posts

To create a new blog post:

```bash
hexo new post "Your Post Title"
```

This will create a new markdown file in `source/_posts/`. Edit the file to add your content.

### Building the Site

To generate the static HTML files:

```bash
hexo clean
hexo generate
```

The compiled site will be in the `public/` directory.

### Deployment to GitHub Pages

To deploy the site to GitHub Pages:

```bash
hexo deploy
```

The deployment is configured to push to the `gh-pages` branch, which GitHub Pages will serve.

## Project Structure

```
.
├── source/          # Source files (markdown posts)
│   └── _posts/      # Blog posts
├── public/          # Generated static site (not committed)
├── themes/          # Blog themes
├── _config.yml      # Blog configuration
├── package.json     # Dependencies
└── node_modules/    # Installed packages
```

## Configuration

The main configuration file is `_config.yml`. You can customize:
- Site title, author, and description
- URL and permalink structure
- Theme and plugins
- Deployment settings

## Commands

- `hexo new post <title>` - Create a new post
- `hexo new page <title>` - Create a new page
- `hexo server` - Start local preview server
- `hexo clean` - Clean generated files
- `hexo generate` - Build the site
- `hexo deploy` - Deploy to GitHub Pages
- `hexo help` - List all commands

## Compilation Note

**Yes, compilation is required before deployment!** 

When you write a new post, Hexo converts your Markdown files into static HTML. The build process (`hexo generate`) creates optimized HTML, CSS, and JavaScript files that are served by GitHub Pages. Without compilation, the website won't be updated.

Typical workflow:
1. Write/edit posts in `source/_posts/`
2. Run `hexo clean && hexo generate` to build
3. Run `hexo deploy` to push to GitHub Pages

## License

MIT
