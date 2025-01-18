const path = require('path');

module.exports = {
  transpileDependencies: [], // Ensures compatibility with modern browsers
  outputDir: path.resolve(__dirname, 'dist'), // Directory for build output
  publicPath: '/', // Absolute path for assets
  assetsDir: 'assets', // Directory for static assets like fonts, images, etc.

  chainWebpack: (config) => {
    // Add a favicon to the HTML plugin
    config.plugin('html').tap((args) => {
      args[0].favicon = 'public/favicon_32x32.ico';
      return args;
    });

    // Add rule to handle font files
    config.module
      .rule('fonts')
      .test(/\.(ttf|woff|woff2|eot|otf)$/) // Matches common font formats
      .use('file-loader')
      .loader('file-loader')
      .options({
        name: 'assets/fonts/[name].[ext]', // Keep file structure clean
        esModule: false, // Disable ES module syntax for file-loader
      })
      .end();
  },

  configureWebpack: {
    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src'), // Shorten imports for cleaner code
      },
    },
    module: {
      rules: [
        {
          test: /\.(ttf|woff|woff2|eot|otf)$/, // Handle all font file formats
          loader: 'file-loader',
          options: {
            name: 'assets/fonts/[name].[ext]', // Output fonts in the assets folder
            esModule: false, // Important to avoid conflicts with imports
          },
        },
      ],
    },
  },
};
