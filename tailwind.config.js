/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./site/**/*.html"],
  theme: {
    extend: {
      boxShadow: {
        'puck': '0 0 4px 0 #0003,0 2px 0 0 #0000001a' 
      }
    },
    fontFamily: {
      'rounded': ['ui-rounded', '-apple-system', 'system-ui', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif']
    },
    container: {
      center: true
    },
    screens: {
      'sm': '375px',
      'md': '900px',
    }
  },
  plugins: [],
}
