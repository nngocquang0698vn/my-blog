{
  "date" : "2022-03-03T13:22:53.24028662Z",
  "deleted" : false,
  "draft" : false,
  "h" : "h-entry",
  "properties" : {
    "in-reply-to" : [ "https://lobste.rs/s/hmpuep/what_s_your_favorite_vim_shortcut_hack" ],
    "syndication" : [ "https://lobste.rs/s/hmpuep/what_s_your_favorite_vim_shortcut_hack#c_do2o84" ],
    "name" : [ "Reply to https://lobste.rs/s/hmpuep/what_s_your_favorite_vim_shortcut_hack" ],
    "published" : [ "2022-03-03T13:22:53.24028662Z" ],
    "post-status" : [ "published" ],
    "content" : [ {
      "html" : "",
      "value" : "I interact with a lot of encoded formats like JSON Web Tokens (JWTs) as well as wanting to unpack URLs, so I've found it super handy to be able to pipe visually selected text into a command, i.e.:\r\n\r\n```\r\n:'<,'>!unpack\r\n```\r\n\r\n([source](https://www.jvt.me/posts/2022/02/01/vim-replace-with-command-execution/))\r\n\r\nOr to do the same with a visual selection:\r\n\r\n```\r\nc<C-R>=system('unpack', @\")<CR><ESC>\r\n```\r\n\r\n([source](https://www.jvt.me/posts/2022/03/03/vim-command-visual-selection/))"
    } ]
  },
  "kind" : "replies",
  "slug" : "2022/03/oyezv",
  "client_id" : "https://www-editor.jvt.me"
}
