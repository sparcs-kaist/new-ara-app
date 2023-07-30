String getCommentContentHtml(double width, String content) {
  return '''
<html>

<head>
  <meta charset="utf-8">
  <meta property="og:url" content="https://newara.sparcs.org">
  <meta property="og:locale" content="ko_KR">
  <meta property="og:locale:alternate" content="en_US">
  <meta name="viewport" content="width=$width,initial-scale=1">
  <meta name="theme-color" content="#ed3a3a">
  <meta name="apple-mobile-web-app-status-bar-style" content="#ed3a3a">
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined">
  <link rel="stylesheet"
    href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&amp;display=swap">
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Raleway:wght@300;400;500;700&amp;display=swap">
  <link href="https://newara.dev.sparcs.org/css/app.34a79d34.css" rel="preload" as="style">
  <link href="https://newara.dev.sparcs.org/js/app.25acc41a.js" rel="preload" as="script">
  <link href="https://newara.dev.sparcs.org/css/app.34a79d34.css" rel="stylesheet">
  <meta name="theme-color" content="#4DBA87">
  <style>
    body {
      min-height: 100vh;
    }
  </style>
</head>

<body>
  <div id="app">
  <div data-v-0144c769="" class="layout post">
    <div data-v-243d0758="" style="font-size: .9rem;">
      $content
    </div>
  </div>
    <div class="__cov-progress"
      style="background-color: rgb(244, 185, 185); opacity: 0; position: fixed; top: 0px; left: 0px; width: 0%; height: 5px; transition: opacity 0.3s ease 0s;">
    </div>
  </div>
  <script src="https://newara.dev.sparcs.org/js/app.25acc41a.js"></script>
</body>

</html>
''';
}
