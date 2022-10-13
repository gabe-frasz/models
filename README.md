# Repo models

<div align="center">

:construction: **Work in progress** :construction:

</div>

<br />

> This little repo was made because I'm too lazy to keep building a project from scratch... and also to learn a bit about bash script.

## :question: What is this about?

This repo is a collection of bash scripts created to automate the project base with Next.js, just to use and be happy :)

### :interrobang: How can you use it?

It's actually very simple, you only have to click the "Use this template" button up there :arrow_up: or down here :arrow_down: to make a copy to your GitHub

[![Use this template](./_docs/use-this-template-btn.png)](https://github.com/SlyCooper-n/models/generate)

But you can go by CLI too

```bash
git clone https://github.com/SlyCooper-n/models.git

# or
gh repo clone SlyCooper-n/models
```

After you have this on your machine, do the following:

```bash
# this will run the sript to create a new project
bash models/ctnewpj.sh
```

## :inbox_tray: Arguments

```bash
bash models/ctnewpj.sh <repoName>
```

## :clipboard: Dependencies options

- [x] Typescript[^marked]
  - It runs `npx create-next-app <repoName> --ts`
- [x] Personal sugestion[^marked]
  - [daisyui](https://daisyui.com/) (Tailwind CSS component library) -> 🤍
  - [@tailwindcss/typography](https://tailwindcss.com/docs/typography-plugin) (Tailwind CSS typography plugin)
  - [react-hot-toast](https://react-hot-toast.com/docs/toast) (custom styled alerts)
  - [phosphor-react](https://phosphoricons.com/) (easy-to-use svg icons)
  - [nookies](https://github.com/maticzav/nookies#readme) (cookie handling on server side)
  - [axios](https://axios-http.com/ptbr/) (handle api requests instead of default fetch API)
  - [swr](https://swr.vercel.app/) (requests with stale-while-revalidate and more)
- [x] Testing[^marked]
  - [vitest](https://vitest.dev)
  - [@testing-library/react](https://testing-library.com/docs/react-testing-library/intro/)
  - [cypress](https://cypress.io)
- [x] Animation
  - [framer-motion](https://www.framer.com/motion/)
  - [lottie-react](https://lottiereact.com/)
- [x] PWA support
  - [next-pwa](https://github.com/shadowwalker/next-pwa#readme)

## :memo: License

[MIT License](https://github.com/SlyCooper-n/models/blob/main/LICENSE) &copy; [Gabriel VS Frasão](https://github.com/SlyCooper-n/)

[^marked]: Selected as true by default
