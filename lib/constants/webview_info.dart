String getNewAraAppHtml(double width, String content) {
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
</head>

<body>
  <div data-v-605472e2="" data-v-88de712e="" class="editor"><!---->
    <div data-v-605472e2="" class="content">
      <div data-v-605472e2="" class="editor-content">
        $content
      </div>
    </div><!---->
  </div><!---->
  <script>
  const allCandidates = document.getElementsByTagName("a");

    for (const cand of allCandidates) {
      const isBookMark = cand.getAttribute('data-bookmark');
      if (!isBookMark) continue;
      const attributes = {
        "data-v-3fc8d1c4" : "",
        "data-v-88de712e" : "",
        "class": "bookmark-box content__bookmark",
        "target": "_blank"
      };
      cand.removeAttribute("data-bookmark");
      cand.removeAttribute("rel");
      for (const key in attributes) {
        cand.setAttribute(key, attributes[key]);
      }
      const link = cand.getAttribute("href");
      console.log(link);
      const newTitle = '<p data-v-3fc8d1c4 class="box-title">' + cand.textContent + ' ></p>';
      cand.textContent = "";
      const newContent = '<p data-v-3fc8d1c4 class="box-info">' + link + '</p>';
      cand.innerHTML = newTitle + newContent;
    }
  </script>
  <script src="https://newara.dev.sparcs.org/js/app.25acc41a.js"></script>
</body>

</html>
''';
}
