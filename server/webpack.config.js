const path = require("path");
const webpackNodeExternals = require("webpack-node-externals");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: "./src/index.js",
  externals: [webpackNodeExternals()],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: "babel-loader",
      },
      {
        test: /\.(html)$/,
        loader: "html-loader",
        options: {
          esModule: false,
        },
      },
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"],
      },
    ],
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        {
          from: "./src/views/",
          to: "./views",
        },
        {
          from: "./src/public/",
          to: "./public",
        },
        {
          from: "./src/routes/db.json",
          to: "./",
        },
      ],
    }),
  ],
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
    clean: true,
  },
  target: "node",
};
