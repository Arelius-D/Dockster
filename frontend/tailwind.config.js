/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{vue,js,ts,jsx,tsx}", // Scan all Vue components and JS/TS files in src
    "./public/index.html",            // Include your index.html file
  ],
  theme: {
    extend: {
      colors: {
        primary: "#007bff",  // Your blue color for buttons and headings
        secondary: "#0056b3", // Darker blue for hover states
        light: "#f4f4f4",    // Light background color
        dark: "#121212",     // Dark background color
      },
      fontFamily: {
        sans: ["Open Sans", "Arial", "sans-serif"], // Default font family
      },
      spacing: {
        128: "32rem",       // Custom spacing for large containers
        144: "36rem",       // Another large spacing option
      },
      borderRadius: {
        xl: "1.5rem",       // Custom border radius
      },
    },
  },
  plugins: [],
};
