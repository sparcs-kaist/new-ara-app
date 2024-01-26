import 'package:sanitize_html/sanitize_html.dart' show sanitizeHtml;
import 'package:flutter/material.dart';

String getContentHtml(String content, {double? width}) {
  /* sanitize_html 패키지에서는 <u> 태그를 제거해버림
     (sanitize_html은 다소 strict하게 sanitizing을 시행함).
     따라서 <u>의 sanitizing을 피하기 위해 sanitize_html이 허용하는 태그
     (sanitize_html 패키지 구현 코드에서 _allowedElements 리스트 확인하기) 중 사용되지 않을 확률이 높은
     <h8> 태그를 사용함(HTML 표준이 아니라 사용될 확률이 거의 없음).
     Sanitizing 직전에 모든 u 태그를 h8 태그로 변경 후 sanitize 후에 다시 추가하는 방식.
     <u> 태그 자체에 XSS 공격 취약점이 있는 것이 아니고 아래 과정에서도 모든 attribute는 지워지므로 어느정도 안전한 방식. */
  String replacedContent = content
      .replaceAll(RegExp('<u(?: [^>]*)?>'), '<h8>')
      .replaceAll('</u>', '</h8>');
  String sanitized = sanitizeHtml(replacedContent)
      .replaceAll('<h8>', '<u>')
      .replaceAll('</h8>', '</u>');

  debugPrint("original html: $content");
  debugPrint("sanitized html: $sanitized");

  return '''
  <html>
    <head>
      <meta name="viewport" content="width=device-width initial-scale=1.0">
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
        blockquote {
          margin: 0;
          padding: 0;
          background-color: #f5f5f5;
          border-left: 5px solid #dbdbdb;
          padding: 0.2em 1.5em;
          display: block;
        }
      </style>
    </head>
    <body>
      $sanitized
    </body>
  </html>
  ''';
}
