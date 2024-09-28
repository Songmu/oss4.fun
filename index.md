# 「{{.Channel.Title}}」とは

「趣味でOSSをやっている者だ」は、OSS作家の [@songmu](https://x.com/songmu) がゲストを交えながら趣味や仕事についての雑談を不定期にお届けするポッドキャスト番組です。感想のTweetは[#oss4fun](https://x.com/search?q=%23oss4fun)をご利用ください。番組への感想・リクエスト・ご連絡はこちらから <https://oss4.fun/voice>

## RSS Feed
<input type="text" value="{{.Channel.FeedURL}}" size="80" readonly>

## Episodes
{{range .Episodes -}}
<dl>
  <dt><a href="{{.URL.Path}}">{{.Title}}</a> ({{.PubDate.Format "2006-01-02 15:04"}})</dt>
  <dd>{{.Subtitle}}</dd>
</dl>
{{end}}
