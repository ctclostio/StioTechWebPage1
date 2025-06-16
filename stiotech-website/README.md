# StioTech Website

A modern, fast, and secure company website built with Astro and Tailwind CSS.

## 🚀 Features

- ⚡ Lightning-fast static site generation with Astro
- 🎨 Beautiful, responsive design with Tailwind CSS
- 🔍 SEO optimized with sitemap generation
- 📱 Mobile-first responsive design
- 🛡️ Secure and scalable
- 🌐 Ready for Vercel deployment

## 📁 Project Structure

```
/
├── public/
│   ├── favicon.svg
│   └── robots.txt
├── src/
│   ├── components/
│   │   ├── Navigation.astro
│   │   └── Footer.astro
│   ├── layouts/
│   │   └── Layout.astro
│   ├── pages/
│   │   ├── index.astro
│   │   ├── about.astro
│   │   ├── services.astro
│   │   └── contact.astro
│   └── styles/
│       └── global.css
├── astro.config.mjs
├── vercel.json
└── package.json
```

## 🧞 Commands

All commands are run from the root of the project:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |

## 🚀 Deployment

This project is configured for easy deployment to Vercel:

1. Push your code to GitHub
2. Import the project in Vercel
3. Deploy with zero configuration

The `vercel.json` file includes all necessary settings for optimal deployment.

## 🛠️ Technologies Used

- **Astro** - Static site generator
- **Tailwind CSS** - Utility-first CSS framework
- **TypeScript** - Type safety (relaxed mode)
- **Vercel** - Deployment platform
