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

  return '''
  <!DOCTYPE html>
  <html>
    <head>
      <meta name="viewport" content="width=device-width initial-scale=1.0">
      <style>

      /*! minireset.css v0.0.3 | MIT License | github.com/jgthms/minireset.css */
      blockquote,body,dd,dl,dt,fieldset,figure,h1,h2,h3,h4,h5,h6,hr,html,iframe,legend,li,ol,p,pre,textarea,ul {
        margin: 0;
        padding: 0
      }

      strong {
        color: #363636;
        font-weight: 700
      }

      a {
        color: #00b8d4;
        text-decoration: underline;
      }

      h1, h2, h3, h4, h5, h6 {
        color: #363636;
        font-weight: 600;
        line-height: 1.125;
      }

      h1 {
        font-size: 32px;
      }

      h2 {
        font-size: 28px;
      }

      h3 {
        font-size: 24px;
      }

      h4 {
        font-size: 20px;
      }

      h5 {
        font-size: 20px;
      }

      h6 {
        font-size: 16px;
      }

      

      

      hr {
        border: none;
        display: block;
        height: 2px;
        margin: 1.5rem 0
      }

      ul {
        list-style: none
      }

      button,input,select,textarea {
        margin: 0
      }

      html {
          -webkit-box-sizing: border-box;
          box-sizing: border-box
          font-family: "Pretendard",sans-serif;
      }

      audio,img,video {
        height: auto;
        max-width: 100%
      }

      table {
        border-collapse: collapse;
        border-spacing: 0
      }

      td,th {
        padding: 0;
        text-align: left
      }

      html {
        background-color: #fff;
        font-size: 16px;
        -moz-osx-font-smoothing: grayscale;
        -webkit-font-smoothing: antialiased;
        min-width: 300px;
        overflow-x: hidden;
        overflow-y: scroll;
        text-rendering: auto;
        -webkit-text-size-adjust: 100%;
        -moz-text-size-adjust: 100%;
        -ms-text-size-adjust: 100%;
        text-size-adjust: 100%
      }

      article,aside,figure,footer,header,hgroup,section {
        display: block
      }

      body,button,input,select,textarea {
        font-family: "Noto Sans KR",sans-serif
      }

      code,pre {
        -moz-osx-font-smoothing: auto;
        -webkit-font-smoothing: auto;
        font-family: monospace;
      }

      code {
        color: #ff3860;
        font-size: .875em;
        font-weight: 400;
        padding: .25em .5em .25em
      }

      code,hr {
        background-color: #f5f5f5
      }

      body {
        color: #4a4a4a;
        font-size: 1rem;
        font-weight: 400;
        line-height: 1.5
      }

      small {
        font-size: .875em
      }

      span {
        font-style: inherit;
        font-weight: inherit
      }

      pre {
        -webkit-overflow-scrolling: touch;
        background-color: #f5f5f5;
        color: #4a4a4a;
        font-size: .875em;
        overflow-x: auto;
        padding: 1.25rem 1.5rem;
        white-space: pre;
        word-wrap: normal
      }

      pre code {
        background-color: transparent;
        color: currentColor;
        font-size: 1em;
        padding: 0
      }

      table td,table th {
        text-align: left;
        vertical-align: top
      }

      table th {
        color: #363636
      }

      html, body {
        margin: 0;
        padding: 0;
      }

      blockquote {
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        border-left: 5px solid #dbdbdb;
        padding: 1em 1.5em;
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
