String getContentHtml(String content) {
  return '''
  <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        img {
          max-width: 100%;
        }
        html, body {
          margin: 0;
          padding: 0;
        }
        a {
          color: #00b8d4;
          text-decoration: underline;
        }
      </style>
    </head>
    <body>
      $content
    </body>
  </html>
  ''';
}
