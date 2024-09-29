# 「{{.Channel.Title}}」とは

「趣味でOSSをやっている者だ」は、OSS作家の [@songmu](https://x.com/songmu) がゲストを交えながら趣味や仕事についての雑談を不定期にお届けするポッドキャスト番組です。感想のTweetは[#oss4fun](https://x.com/search?q=%23oss4fun)をご利用ください。番組への感想・リクエスト・ご連絡はこちらから <https://oss4.fun/voice>

## Subscribe

- [![RSS](/images/icon/rss.svg)]({{.Channel.FeedURL.Path}})
- [![Overcast](/images/icon/overcast.png)](https://overcast.fm/itunes1771210971/)
- [![LISTEN](/images/icon/listen.svg)](https://listen.style/p/oss4fun?CCWEZTnF)
- [![Apple Podcasts](/images/icon/apple-podcast.png)](https://podcasts.apple.com/jp/podcast/id1771210971)
- [![Spotify](/images/icon/spotify.png)](https://open.spotify.com/show/56iQ3wiyWWeSAoJfjmoJ2f?si=dPPtngBVT2ekNxhd9V51ig)
- [![Amazon Music](/images/icon/amazon-music.png)](https://music.amazon.co.jp/podcasts/5c9311c4-6153-4e3a-b442-3d60dee1d1d6/%E8%B6%A3%E5%91%B3%E3%81%A7oss%E3%82%92%E3%82%84%E3%81%A3%E3%81%A6%E3%81%84%E3%82%8B%E8%80%85%E3%81%A0)
- [![Pocket Casts](/images/icon/pocket-casts.svg)](https://pca.st/x8mjk9j6)
- [![Android](/images/icon/android.png)](https://subscribeonandroid.com/oss4.fun/feed.xml)

## Episodes
{{range .Episodes -}}
<dl>
  <dt><a href="{{.URL.Path}}">{{.Title}}</a> ({{.PubDate.Format "2006-01-02 15:04"}})</dt>
  <dd>{{.Subtitle}}</dd>
</dl>
{{end}}
