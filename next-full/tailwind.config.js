/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      /* colors: {
        brand: {
          100: "#f5f5f5",
        }
      } */
    },
  },
  plugins: [
    // require("@tailwindcss/forms"),
    // require("tailwind-scrollbar"),
    // ...
  ],
};
