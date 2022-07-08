#! /bin/bash

# * provide a repo name
repoName=$1
while [ -z "$repoName" ]
do
  echo 'Provide a repository name'
  read -r -p $'Repository name: ' repoName
done

# * choose the dependencies
# source code of the function below: https://stackoverflow.com/questions/45382472/bash-select-multiple-answers-at-once, https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu/415155#415155
function prompt_for_multiselect {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi 
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      if [[ ${arr[option]} == true ]]; then
        arr[option]=
      else
        arr[option]=true
      fi
      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options
    local defaults

    IFS=';' read -r -a options <<< "$2"
    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi
    local selected=()

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}
prompt_for_multiselect result "Typescript;Personal sugestion;Testing (based on Vitest);Animations;PWA support;" "true;true;true;;"

# ! [0] => Typescript; [1] => Personal sugestion; [2] => Testing (based on Vitest); [3] => Animations; [4] => PWA support;

# TODO FINSIH CONFIGURATION WITH TYPESCRIPT AND JAVASCRIPT
# * Create a new project with Next.js
if (${selected[0]}) ; then
  echo 'Creating a new project with TypeScript'
  npx create-next-app $repoName --ts
else
  echo 'Creating a new project with JavaScript'
  npx create-next-app $repoName
fi
cd $repoName


# * .editorConfig setup
echo "Configuring .editorconfig"
echo >> .editorConfig "# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

[*]
indent_style = space
indent_size = 2
tab_width = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true"


# * Tailwind config
echo "Configuring Tailwind CSS"
npm install -D tailwindcss postcss autoprefixer @tailwindcss/forms tailwind-scrollbar && npx tailwindcss init -p
if (${selected[1]}) ; then
  rm tailwind.config.js && echo >> tailwind.config.js '/** @type {import('tailwindcss').Config} */
  module.exports = {
    content: [
      "./pages/**/*.{js,ts,jsx,tsx}",
      "./components/**/*.{js,ts,jsx,tsx}",
      ],
    theme: {
      extend: {},
    },
    plugins: [
      // require("@tailwindcss/forms"),
      // require("tailwind-scrollbar"),
      require("daisyui"),
    ],
  }'
else  
  rm tailwind.config.js && echo >> tailwind.config.js '/** @type {import('tailwindcss').Config} */
  module.exports = {
    content: [
      "./pages/**/*.{js,ts,jsx,tsx}",
      "./components/**/*.{js,ts,jsx,tsx}",
      ],
    theme: {
      extend: {},
    },
    plugins: [
      // require("@tailwindcss/forms"),
      // require("tailwind-scrollbar"),
    ],
  }'
fi
rm styles/globals.css styles/Home.module.css && echo >> styles/globals.css "@tailwind base;
@tailwind components;
@tailwind utilities;"


# * pages/ setup
echo "Organizing pages directory"
rm pages/index.tsx && echo >> pages/index.tsx 'import type { NextPage } from "next";

const Home: NextPage = () => {
  return <div className="m-0">Hello World!</div>;
};

export default Home;'
echo >> pages/_document.tsx 'import { Head, Html, Main, NextScript } from "next/document";
import Script from "next/script";

export default function Document() {
  return (
    <Html lang="en">
      <Head>
        <meta charSet="utf-8" />

        {/* <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" /> */}

        <link href="/favicon.ico" rel="icon" type="image/ico" sizes="16x16" />
        {/* <link rel="apple-touch-icon" href="/apple-icon.png"></link> */}

        {/* <link rel="manifest" href="/manifest.json" /> */}
        <meta name="theme-color" content="#317EFB" />

        <Script
          crossOrigin="anonymous"
          strategy="beforeInteractive"
          src="https://polyfill.io/v3/polyfill.min.js"
        />
      </Head>

      <body>
        <Main />

        <NextScript />
      </body>
    </Html>
  );
}'

# * public/ setup
echo "Organizing public directory"
rm public/vercel.svg
mkdir public/icons public/images
echo >> public/icons/index.ts 'export * from "./"'
echo >> public/images/index.ts 'export * from "./"'
echo >> public/robots.txt '# Allow all crawlers for indexing

User-agent: *
Allow: /

# Sitemap: link here if any'

# * components/ setup
echo "Creating components directory"
mkdir components components/layouts components/modules components/widgets
echo >> components/layouts/index.ts 'export * from "./"'
echo >> components/modules/index.ts 'export * from "./"'
echo >> components/widgets/index.ts 'export * from "./"'

# * core/ setup
echo "Creating core directory"
mkdir core core/contexts core/hooks core/repositories core/services core/tests core/types core/use-cases core/utils
echo >> core/contexts/index.ts 'export * from "./"'
echo >> core/hooks/index.ts 'export * from "./"'
echo >> core/repositories/index.ts 'export * from "./"'
echo >> core/services/index.ts 'export * from "./"'
echo >> core/tests/index.ts 'export * from "./"'
echo >> core/types/index.ts 'export * from "./"'
echo >> core/use-cases/index.ts 'export * from "./"'
echo >> core/utils/index.ts 'export * from "./"'


# * tsconfig.json setup
echo "Configuring tsconfig.json"
if (${selected[2]}) ; then
  rm tsconfig.json && echo >> tsconfig.json '{
    "compilerOptions": {
      "target": "es5",
      "lib": ["dom", "dom.iterable", "esnext"],
      "allowJs": true,
      "skipLibCheck": true,
      "strict": true,
      "forceConsistentCasingInFileNames": true,
      "noEmit": true,
      "esModuleInterop": true,
      "module": "esnext",
      "moduleResolution": "node",
      "resolveJsonModule": true,
      "isolatedModules": true,
      "jsx": "preserve",
      "incremental": true,
      "types": ["vitest/globals"],
      "baseUrl": ".",
      "paths": {
        "@core/*": ["core/*"],
        "@components/*": ["components/*"],
        "@/icons": ["public/icons"],
        "@/images": ["public/images"],
      },
    },
    "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
    "exclude": ["node_modules"]
  }'
else
  rm tsconfig.json && echo >> tsconfig.json '{
    "compilerOptions": {
      "target": "es5",
      "lib": ["dom", "dom.iterable", "esnext"],
      "allowJs": true,
      "skipLibCheck": true,
      "strict": true,
      "forceConsistentCasingInFileNames": true,
      "noEmit": true,
      "esModuleInterop": true,
      "module": "esnext",
      "moduleResolution": "node",
      "resolveJsonModule": true,
      "isolatedModules": true,
      "jsx": "preserve",
      "incremental": true,
      "baseUrl": ".",
      "paths": {
        "@core/*": ["core/*"],
        "@components/*": ["components/*"],
        "@/icons": ["public/icons"],
        "@/images": ["public/images"],
      },
    },
    "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
    "exclude": ["node_modules"]
}'
fi

# TODO FINSIH CONFIGURATION
# * Install sugested dependencies if chosen
if (${selected[1]}) ; then
  echo "Installing sugested dependencies"
  echo "Using npm"
  echo 'List of dependencies to be installed:
  - daisyui (Tailwind CSS component library) => 🤍
  - react-hot-toast (custom styled alerts)
  - phosphor-react (easy-to-use svg icons)
  - nookies (cookie handling on server side)
  - axios (handle api requests instead of default fetch API)
  - swr (requests with stale-while-revalidate and more)'

  npm install daisyui react-hot-toast phosphor-react nookies axios swr
fi

# TODO FINSIH CONFIGURATION
# * tests setup if chosen
if (${selected[2]}) ; then
  echo "Organizing tests directory"
  echo "Using npm"
  echo 'List of tests dependencies
  - vitest
  - jsdom
  - @testing-library/jest-dom
  - @testing-library/react
  - @testing-library/user-event
  - c8'
  npm install -D vitest jsdom @testing-library/react @testing-library/user-event c8
  echo >> core/tests/setup.ts 'import "@testing-library/jest-dom";'
  echo >> vitest.config.ts 'import { defineConfig } from "vitest/config";

  export default defineConfig({
    test: {
      globals: true,
      environment: "jsdom",
      setupFiles: ["./tests/setup.ts"],
      coverage: {
        enabled: true,
        exclude: ["**/*.{test,spec}.{js,ts,jsx,tsx}"],
      },
    },
  });'
  npm set-script "test" "vitest run --config ./vitest.config.ts"
  npm set-script "test:watch" "vitest --config ./vitest.config.ts"
fi

# TODO FINSIH CONFIGURATION
# * animations setup if chosen
if (${selected[3]}) ; then
  echo "Configuring animations"
  echo "Using npm"
  echo 'List of animations dependencies
  - framer-motion
  - lottie-react'
  npm install framer-motion lottie-react
fi

# TODO REVIEW CONFIGURATION
# * PWA support setup if chosen
if (${selected[4]}) ; then
  npm install next-pwa
  # next.config.js setup with PWA support
  echo "Configuring next.config.js with PWA support"
  rm next.config.js && echo >> next.config.js "/** @type {import('next').NextConfig} */
  const nextConfig = {
    reactStrictMode: true,
  };

  module.exports = nextConfig;

  // PWA configuration
  const withPWA = require('next-pwa')
  const runtimeCaching = require('next-pwa/cache')

  module.exports = withPWA({
    pwa: {
      dest: 'public',
      runtimeCaching,
    },
  })"

  # manifest.json setup
  echo "Creating manifest.json"
  echo >> public/manifest.json '{
  "name": "PWA model",
  "short_name": "PWA model",
  "theme_color": "#fafafa",
  "background_color": "#ffffff",
  "display": "standalone",
  "orientation": "portrait",
  "scope": "/",
  "start_url": "/",
  "icons": [
    {
      "src": "icons/icon-72x72.png",
      "sizes": "72x72",
      "type": "image/png"
    },
    {
      "src": "icons/icon-96x96.png",
      "sizes": "96x96",
      "type": "image/png"
    },
    {
      "src": "icons/icon-128x128.png",
      "sizes": "128x128",
      "type": "image/png"
    },
    {
      "src": "icons/icon-144x144.png",
      "sizes": "144x144",
      "type": "image/png"
    },
    {
      "src": "icons/icon-152x152.png",
      "sizes": "152x152",
      "type": "image/png"
    },
    {
      "src": "icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/icon-384x384.png",
      "sizes": "384x384",
      "type": "image/png"
    },
    {
      "src": "icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "splash_pages": null
}'
fi

# TODO CREATE TEMPLATE
# * README.md template setup
echo "Creating README.md template"
rm README.md && echo >> README.md "# '$repoName'

> This is a template for a new project based on Next.js and created with bash scripts.
"



# * Info message
echo "Template built successfully!"
echo "For futher information, visit the README.md file"

# * run
npm run dev
