import { Html, Head, Main, NextScript } from "next/document";
import Script from "next/script";

export default function Document() {
  return (
    <Html>
      <Head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="initial-scale=1.0, width=device-width" />

        {/* <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" /> */}
        {/* <link rel="manifest" href="/manifest.json" /> */}
        {/* <link
          href="/favicon.ico"
          rel="icon"
          type="image/ico"
          sizes="16x16"
        /> */}
        {/* <link rel="apple-touch-icon" href="/apple-icon.png"></link> */}

        <meta name="theme-color" content="#317EFB" />

        <Script
          crossOrigin="anonymous"
          strategy="beforeInteractive"
          src="https://polyfill.io/v3/polyfill.min.js"
        ></Script>
      </Head>

      <body>
        <Main />

        <NextScript />
      </body>
    </Html>
  );
}
