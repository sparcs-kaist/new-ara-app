import 'package:sanitize_html/sanitize_html.dart' show sanitizeHtml;
import 'package:flutter/material.dart';

String getContentHtml(String content, {double? width}) {
  String replacedContent = content
      .replaceAll(RegExp('<u(?: [^>]*)?>'), '<sup>')
      .replaceAll('</u>', '</sup>');
  String sanitized = sanitizeHtml(replacedContent)
      .replaceAll('<sup>', '<u>')
      .replaceAll('</sup>', '</u>');

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
