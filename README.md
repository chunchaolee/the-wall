The Wall - Indie 音樂資訊平台
===

目錄
---
* [INTRODUCTION](#0)
  * [PRODUCT OBJECTIVES](#0.1)
  * [PRODUCT SCOPE](#0.2)
* [1. 入門](#1)
* [2. 環境設定](#2)
    * [2.1 devise.rb設定](#2.1)
    * [2.2 facebook.yml設定](#2.2)
    * [2.3 spotify.yml設定](#2.3)
    * [2.4 youtube.yml設定](#2.4)
    * [2.5 email.yml設定](#2.5)
    * [2.6 callback url設定](#2.6)
* [3. Rake設定](#3)
    * [3.1 使用dev.rake](#3.1)
    * [3.2 設定並執行get_event.rake](#3.2)
    * [3.3 使用notification.rake](#3.3)
* [4. 備註](#4)
    * [4.1 第三方API和工具應用](#4.1)
    * [4.2 [Demo Day] 備審資料](#4.2)
    * [4.3 如何取得Youtube嵌入式網址](#4.3)
    * [4.4 如何取得藝人Spotify ID](#4.4)



<h2 id="0">INTRODUCTION</h2>
---
因應音樂​​產業變化帶來的使用者習慣改變，針對喜歡獨立音樂的使用者族群開發了該產品，產品的訴求是​​「集中並彙整獨立音樂資訊及活動資訊」、「整合數位影音串流」，透過網路及數位串流垂直整合獨立音樂的資訊，讓使用者能用更簡單便利、更直接的接觸跟欣賞獨立音樂。

<h3 id="0.1">PRODUCT OBJECTIVES</h3>
<hr>
<h4>解決的問題</h4>

1. 台灣過度分散的獨立音樂資訊及活動資訊<br>
2. 獨立音樂的社群力侷限在各Live House及特定音樂網路社群<br>

<h4>整合的項目</h4>

1. 整合獨立創作者在影音串流(Youtube)及數位音樂串流(Spotify)上的創作<br>
2. 整合獨立音樂市場上主要 Live House 在 facebook 上所公開的活動及表演資訊<br>

<h4>目標</h4>

1. 透過網路及數位影音串流，集中並垂直整合獨立音樂的資訊，讓使用者對於獨立音樂、獨立音樂創作者、獨立音樂表演空間能夠有更深入的了解。<br>
2. 透過文字資訊與數位音樂串流平台(Spotify)及線上影音(Youtube)的結合，讓使用者能更直接的接觸到獨立音樂，促使使用者主動挖掘、探索獨立音樂，重拾過往在唱片行或其他實體零售通路挖掘寶藏的熱情。<br>

<h3 id="0.2">PRODUCT SCOPE</h3>
<hr>
「The Wall - Indie 音樂資訊平台」是由Ruby on Rails所建構出來的Web Application，且符合RWD，並提供了以下功能及服務：


1. Authentication(權限認證)
    * 3種註冊及登入管道：
        * 透過email註冊及登入
        * Facebook Sign Up & Sign In
        * Spotify Sign Up & Sigh In
    * 3種權限：
      * 訪客：瀏覽網站前台
      * 一般會員：瀏覽網站前台、管理會員中心(User Profile)
      * 管理員：瀏覽網站前台、管理會員中心(User Profile)和管理網站後台

2. Web Crawler(網路爬蟲)
    * Facebook Events in Live House Fan page

3. Stream Media Integration(串流服務整合)
    * 「活動資訊頁面」、「藝人資訊頁面」內及「表演動態」提供 Youtube 影音串流。
    * 「活動資訊頁面」、「藝人資訊頁面」內及「表演動態」提供 Spotify 數位音樂串流、關注 Spotify 藝人。

4. 網站前台
    * 網站首頁「活動總覽」依據最近期活動排序，以活動 Cover、演出者及表演場地三種資訊讓使用者快速得知活動消息。
    * 網站「表演動態」依據最新更新至網站的活動作排序，主打在該頁面即時呈現出各活動演出者在 Youtube 及 Spotify 的作品，讓使用者可以快速欣賞演出者的音樂作品。
    * 網站「會員中心」提供編輯會員 email 及 name 資料，並顯示已經追蹤的活動及近期瀏覽過的表演活動有哪些，讓使用者能管理已追蹤及感興趣的活動。
    * 透過點擊表演活動中的演出者/藝人名稱超連結可以瀏覽「藝人資訊頁面」，頁面內包含了藝人的 Youtube、Spotify 和近期的表演活動。
    * 網站「搜尋」功能，提供使用者針對網站上的表演活動依據日期、演出者名稱、地點、城市或任何關鍵字做搜尋，讓使用者在探索獨立音樂時能有更流暢的體驗。
    * 作為管理員，除了後台外可以直接在前台「活動資訊頁面」內執行表演活動的「編輯」、「清除演出者資料」，或在「更新演出者Stream資料」或「新增藝人」區塊執行artist資料的即時新增或更新。

5. 網站後台
    * 「表演活動清單」提供活動編輯、刪除功能，並能依據時間、日期、城市、地點、瀏覽數、收藏數等欄位作排序，再加上後台搜尋，讓管理員能更便於管理。
    * 「使用者清單」提供刪除使用者的功能，並能依據登入管道、權限、登入次數等欄位作排序，再加上後台搜尋，讓管理員能更便於管理。
    * 「藝人清單」提供新增、更新及刪除藝人的功能，並能依據更新時間或創建時間等欄位作排序，再加上後台搜尋，讓管理員能更便於管理。
      * 新增 artist
        * 只需輸入 artist name，系統會依據 artist name 透過 Youtube API & Spotify Web API 取得對應的 Youtube 及 Spotify 資料並自動新增在「藝人資訊頁面」中。
        * 系統會自動比對沒有演出者的活動，當自動比對出對應演出者/藝人後，系統會將該藝人的名稱、Youtube及Spotify資訊同步到表演活動中。
      * 更新 artist
        * 依據更動後的 artist name、Youtube URL 及 Artist Spotify ID，將藝人資料做更新。
        * 系統會自動更新平台中該藝人的所有表演活動，同步更新的項目有表演活動中演出者的名稱、 Youtube 及 Spotify 資料。
        * 同步藝人資料與表演活動的過程中，若表演活動中沒有 Youtube 的影音串流或 Spotify 的音樂串流，則系統會將有缺的演出者/藝人的 Youtube 和 Spotify 資料更新至活動中。
        * 系統也會自動比對目前產品平台中沒有演出者的活動，當自動比對到對應演出者後後，系統會將演出者/藝人的名稱、Youtube 和 Spotify 資料更新至活動中。
        * 透過點擊「重新取得Stream Data」，系統會重新依據 artist name 透過 Youtube API & Spotify Web API 取得對應的 Youtube 及 Spotify 資料並自動更新藝人資料及同步更新關聯活動內的資料。


6. Event Follow-Up(活動追蹤)
    * 作為會員，可以透過點擊「♥」收藏或取消收藏該表演活動。
    * 在網站「會員中心」能檢視已收藏的所有活動。

7. Email Notification(Email通知)
    * 會員點擊「♥」後會收到收藏該表演活動的email通知。
    * 每週一系統會自動發送電子報(Weekly Digest)給所有會員，內容為最新發佈的5筆表演活動及平台時下熱門的5筆表演活動。
    * 表演活動進入最後一週黃金決策期時，收藏該活動的所有會員都會再次收到系統自動發送的活動通知。
<br />
<hr>

<h2 id="1">1. 入門</h2>

首先將Rails專案透過git clone下載到本地端(local)

```
  $ git clone https://github.com/chunchaolee/the-wall
```

接著進入專案目錄下執行`bundle install`安裝。

```
  $ bundle install
```

安裝完後，您需要run migration來建立tables

```
  $ rails db:migrate
```


<h2 id="2">2. 環境設定</h2>
<h3 id="2.1">2.1 devise.rb設定</h3>

在本地端使用開發環境時，請在rails專案資料夾 `config/` 新增 `facebook.yml` 及 `spotify.ym` 兩個檔案，
然後開啟 `config/initializers/devise.rb` 檔案，可以看到下方程式碼，若當前是開發環境則會透過 `facebook.yml` 及 `spotify.yml` 載入串接Facebook API需要的app_id及secret和串接Spotify需要的client_id及client_secret。

```
if Rails.env.development?
  # facebook
  fb_config = Rails.application.config_for(:facebook)
  config.omniauth :facebook,
  fb_config["app_id"],
  fb_config["secret"]

  # spotify
  spotify_config = Rails.application.config_for(:spotify)
  config.omniauth :spotify,
  spotify_config["client_id"], 
  spotify_config["client_secret"],
  scope: 'user-read-private playlist-read-private user-read-email user-follow-modify user-library-modify'

elsif Rails.env.production?
  # facebook
  config.omniauth :facebook,
  ENV['FACEBOOK_APP_ID'],
  ENV['FACEBOOK_APP_SECRET']
  
  # spotify
  config.omniauth :spotify,
  ENV['SPOTIFY_CLIENT_ID'],
  ENV['SPOTIFY_CLIENT__SECRET'],
  scope: 'user-read-private playlist-read-private user-read-email user-follow-modify user-library-modify'
 
end 
```


<h3 id="2.2">2.2 facebook.yml設定</h3>

接著我們需要先設定 `facebook.yml` 檔案的內容，請至[facebook for developers](https://developers.facebook.com/apps) 申請並取得app_id、seceret及API token，取得後請在 `facebook.yml` 檔案內輸入以下內容：

```
development:
  app_id: 輸入取得的app_id
  secret: 輸入取得的secret
  api_token: 輸入取得的API token
```

<h3 id="2.3">2.3 spotify.yml設定</h3>

另外 `spotify.yml` 的設定也一樣，請至[Spotify Developer](https://developer.spotify.com/my-applications/) 申請並取得client_id及client_secret，取得後請在 `spotify.yml` 檔案內輸入以下內容：

```
development:
  client_id: 輸入取得的client_id
  client_secret: 輸入取得的client_secret
```

<h3 id="2.4">2.4 youtube.yml設定</h3>

由於會需要Youtube影音串流服務，所以請新增 `youtube.yml` ，請至[Youtube Data API v3](https://console.developers.google.com/apis/library/youtube.googleapis.com/?id=125bab65-cfb6-4f25-9826-4dcc309bc508&showFTMessage=false) 申請app_id，並請將申請取得的app_id輸入 `youtube.yml` 檔案中，

```
development:
  app_id: 輸入取得的app_id
```

<h3 id="2.5">2.5 email.yml設定</h3>

平台功能自動執行email notification，需要新增 `email.yml` ，並進行以下設置，

```
development:
  URL: "http://localhost:3000"
  GMAIL_USERNAME: "發出通知的email帳號"
  GMAIL_PASSWORD: "發出通知的email密碼"
```

<h3 id="2.6">2.6 callback url設定</h3>

由於平台提供Facebook & Spotify 登入功能，所以在申請Facebook & Spotify APP Key的同時，
也請將callback url一併設定好，格式如下，


```
<your-application-base-url>/<devise-entity>/auth/<provider>/callback
```

舉個本地端的spotify callback url作為實際範例：

```
http://localhost:3000/users/auth/spotify/callback
```


<h2 id="3">3. Rake設定/使用</h2>
<h3 id="3.1">3.1 使用dev.rake</h3>

透過 `dev.rake` 內的create_artists task自動建立基本的artists

```
  $ rails dev:create_artists
```

<h3 id="3.2">3.2 設定並執行get_event.rake</h3>
在執行task時，會透過以下程式碼取得權限，

```
if Rails.env.development?
  # local用
  fb_config = Rails.application.config_for(:facebook)
  @graph = Koala::Facebook::API.new(fb_config["api_token"])
elsif Rails.env.production?
  # heroku用
  @graph = Koala::Facebook::API.new(ENV['FACEBOOK_API_TOKEN'])
end
```

```
if Rails.env.development?
  # local用
  yt_config = Rails.application.config_for(:youtube)
  url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{yt_config["app_id"]}&q=#{searching}&type=video&maxResults=1"
elsif Rails.env.production?
  # heroku用
  url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{ENV['YOUTUBE_APP_ID']}&q=#{searching}&type=video&maxResults=1"
end
```

透過執行rake檔取得指定 facebook events 資料及自動比對演出者資訊，然後自動呈現在平台頁面中，執行方式如下：

```
  $ rails get_event:fb_event_new
```

<h3 id="3.3">3.3 使用notification.rake</h3>

系統中提供進入最後一週黃金決策期時，收藏該活動的所有會員都會再次收到系統自動發送的活動通知就是需要透過該rake執行task自動發送7天後表演活動即將開演的通知。就是透過排程執行下方task，

```
  $ rails notification:event
```

每週一系統發送Weekly Digest給所有會員，內容為最新發佈的5筆表演活動及平台時下熱門的5筆表演活動。就是透過排程執行下方task，

```
  $ rails notification:news_letter
```


<h2 id="4">4. 備註</h2>

以下提供實際上線的Web Application供參考，
[The Wall - Indie 音樂資訊平台](https://thewall-indiemusic.herokuapp.com/)

<h3 id="4.1">4.1 第三方API和工具應用</h3>

* 使用到的API：Facebook API、Youtube Data API v3 和 Spotify Web API
* Authentication  and OAuth : [Devise](https://github.com/plataformatec/devise)  ,  [Omniauth-Facebook](https://github.com/mkdynamic/omniauth-facebook) , [Omniauth-Spotify](https://github.com/icoretech/omniauth-spotify) , 
* Third-Party API：[Koala](https://github.com/arsduo/koala) , [Rspotify](https://github.com/guilhermesad/rspotify) 
* HTTP client and tools：[RESTClient](https://github.com/rest-client/rest-client)  
* Pagination：[Kaminari](https://github.com/kaminari/kaminari) 
* Search：[Ransack](https://github.com/activerecord-hackery/ransack)  
* Testing：[FFaker](https://github.com/ffaker/ffaker) 
* Database tools：[Ruby-pg](https://github.com/ged/ruby-pg) 

<h3 id="4.2">4.2 [Demo Day] 備審資料</h3>

[[Demo Day] 備審資料 The Wall - Indie 音樂資訊平台](https://docs.google.com/presentation/d/1cVVG7VWQAVsUJIi4HUPGDTcQ2dSwbdtdi6i7mp3rg14/edit#slide=id.p) 

<h3 id="4.3">4.3 如何取得Youtube嵌入式網址</h3>

作為管理員，若要手動更新 Youtube 影音內容時，需要用到Youtube嵌入式網址，方法如下，

1. 開啟要抓取的 Youtube 影音網頁。
2. 點擊影音視頻下方的「分享」。
3. 點擊「分享」目錄下的「嵌入」。
4. 複製 iframe 中 src屬性內 `?` 之前的網址取得Youtube嵌入式網址，範例如下：

```
<!-- 完整的 ifram 程式碼-->
<iframe width="560" height="315" src="https://www.youtube.com/embed/PzXue624DFQ?rel=0&amp;controls=0&amp;showinfo=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
```

要取得的Youtube嵌入式網址如下，

```
https://www.youtube.com/embed/PzXue624DFQ
```


<h3 id="4.4">4.4 如何取得藝人Spotify ID</h3>

作為管理員，若要手動更新 Spotify 影音內容時，需要用到藝人Spotify ID，取得方法如下，

<h4><方式ㄧ> 透過Spotify「網路播放器」</h4>

1. 使用「搜尋」功能查詢藝人名稱。
2. 點擊搜尋到的藝人，進入網頁版Spotify藝人頁面。
3. 複製網頁網址中 `https://open.spotify.com/artist/` 後面的字串取得藝人Spotify ID，範例如下，

```
  <!-- 搜尋：宇多田光 -->
  https://open.spotify.com/artist/7lbSsjYACZHn1MSDXPxNF2
```

要取得的藝人Spotify ID如下，

```
  7lbSsjYACZHn1MSDXPxNF2
```


<h4><方式二> 透過Spotify行動裝置或電腦版Application</h4>

1. 使用「搜尋」功能查詢藝人名稱。
2. 點擊搜尋到的藝人，進入App中的Spotify藝人頁面。
3. 點擊在「關注」旁的「・・・」按鈕展開更多選項。
4. 點擊在更多選項中的「分享」展開分享功能列。
5. 點擊最後一個「複製多個 Spotify URI」。
6. 複製「複製多個 Spotify URI」內容中 `spotify:artist:` 之後的字串取得藝人Spotify ID，範例如下，

```
  <!-- 宇多田光 的「複製多個 Spotify URI」內容 -->
  spotify:artist:7lbSsjYACZHn1MSDXPxNF2
```

要取得的藝人Spotify ID如下，

```
  7lbSsjYACZHn1MSDXPxNF2
```



