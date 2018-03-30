The Wall - Indie 音樂資訊平台
===
「The Wall - Indie 音樂資訊平台」是由Ruby on Rails所建構出來的Web Application，且符合RWD，並提供了以下功能及服務：

- 平台提供透過Facebook、Spotify帳號以及一般註冊的方式註冊成為平台會員。
- 平台提供透平台會員帳號、Facebook或Spotify帳號進行登入。
- 平台的「活動總覽」頁面提供各Live House的表演活動。
- 平台的「表演動態」頁面提供平台內最新更新的活動資訊及熱門活動。
- 平台每天定時將各Live House所新建立的Facebook Events自動更新在平台表演活動資訊中。
- 表演活動內容頁面除了文字資訊外，也提供了Youtube影音串流及Spotify數位音樂串流的內容。
- 會員可以對感興趣的表演活動透過點擊頁面上的「♥」收藏表演活動。
- 會員點擊「♥」後會收到收藏該表演活動的email通知。
- 表演活動進入最後一週黃金決策期時，收藏該活動的所有會員都會再次收到系統自動發送的活動通知。
- 平台「會員中心」頁面中的「Edit Profile」提供更新個人資料的功能。
- 平台「會員中心」頁面中可以檢視會員自己所追蹤的活動資訊。
- 平台「會員中心」頁面中可以檢視會員自己最近瀏覽過的活動資訊。
- 平台提供即時搜尋平台內所有的表演活動資訊。
- 平台上的活動資訊可以依據表演時間、瀏覽數量及收藏數量進行排序。
- 平台「後台」提供「表演活動清單」，並可以依據活動日期、活動名稱、活動時間、演出者、城市、地點、瀏覽數及收藏數進行排序。
- 平台「後台」提供「使用者清單」，並可以依據註冊日期、登入方式、管理權限、使用者名稱、使用者email及登入次數進行排序。
- 管理者可以在「後台」編輯或刪除指定的表演活動。
- 管理者可以在「後台」刪除指定的使用者。
- 平台「後台」提供更便於管理的進階搜尋。


Introduction
---
因應音樂​​產業變化帶來的使用者習慣改變，針對喜歡獨立音樂的使用者族群開發了該產品，產品的訴求是​​「集中並彙整獨立音樂資訊及活動資訊」、「整合數位影音串流」，透過網路及數位串流垂直整合獨立音樂的資訊，讓使用者對於獨立音樂、獨立音樂創作者及其作品能夠有更深入的了解。


目錄
---
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



<h2 id="1">1. 入門</h2>
首先將Rails專案透過git clone下載到本地端(local)
```
  $ git clone https://github.com/chunchaolee/the-wall
```
 
接著執行`bundle install`安裝它。
```
  $ bundle install
```

安裝完後，您需要run migration來建立tables
```
  $ rails db:migrate
```


<h2 id="2">2. 環境設定</h2>
<h4 id="2.1">2.1 devise.rb設定</h4>
在本地端使用開發環境時請，請在`config/`新增`facebook.yml`及`spotify.yml`兩個檔案，
然後開啟`config/initializers/devise.rb`檔案，啟用下方程式碼，才能透過`facebook.yml`載入串接Facebook API所需要的app_id及secret。
```
  fb_config = Rails.application.config_for(:facebook)
  config.omniauth :facebook,
  fb_config["app_id"],
  fb_config["secret"]
```

一樣在`config/initializers/devise.rb`檔案，啟用下方程式碼，才能透過`spotify.yml`載入串接Spotify API所需要的client_id、client_secret。
```
  spotify_config = Rails.application.config_for(:spotify)
  config.omniauth :spotify,
  spotify_config["client_id"], 
  spotify_config["client_secret"],
  scope: 'user-read-private playlist-read-private user-read-email user-follow-modify user-library-modify'
```

<h4 id="2.2">2.2 facebook.yml設定</h4>
接著我們需要先設定`facebook.yml`檔案的內容，請至[facebook for developers](https://developers.facebook.com/apps)申請並取得app_id、seceret及API token，取得後請在 `facebook.yml`檔案內輸入以下內容：

```
development:
  app_id: 輸入取得的app_id
  secret: 輸入取得的secret
  api_token: 輸入取得的API token
```

<h4 id="2.3">2.3 spotify.yml設定</h4>
另外 `spotify.yml` 的設定也一樣，請至[Spotify Developer](https://developer.spotify.com/my-applications/)申請並取得client_id及client_secret，取得後請在 `spotify.yml` 檔案內輸入以下內容：

```
development:
  client_id: 輸入取得的client_id
  client_secret: 輸入取得的client_secret
```

<h4 id="2.4">2.4 youtube.yml設定</h4>
由於會需要Youtube影音串流服務，所以請新增 `youtube.yml`，並請將申請取得的app_id輸入 `youtube.yml` 檔案中，

```
development:
  app_id: 輸入取得的app_id
```

<h4 id="2.5">2.5 email.yml設定</h4>
平台功能自動執行email notification，需要新增 `email.yml`，並進行以下設置，

```
development:
  URL: "http://localhost:3000"
  GMAIL_USERNAME: "發出通知的email帳號"
  GMAIL_PASSWORD: "發出通知的email密碼"
```

<h4 id="2.6">2.6 callback url設定</h4>
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
<h4 id="3.1">3.1 使用dev.rake</h4>
透過 `dev.rake` 內建立的create_artists task自動建立artist table

```
  $ rails dev:create_artists
```

<h4 id="3.2">3.2 設定並執行get_event.rake</h4>
在本地端得開發環境需啟用檔案內以下程式碼，

```
  fb_config = Rails.application.config_for(:facebook)
  @graph = Koala::Facebook::API.new(fb_config["api_token"])
```

及

```
  yt_config = Rails.application.config_for(:youtube)
  url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + yt_config["app_id"] + "&q=" + searching + "&type=video&maxResults=1"
```

並隱蔽或移除遠端用的程式碼，如下

```
  # heroku用
  # @graph = Koala::Facebook::API.new(ENV['FACEBOOK_API_TOKEN'])
```

以及

```
  # heroku用
  # url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + ENV['YOUTUBE_APP_ID'] + "&q=" + searching + "&type=video&maxResults=1"

```

上述程式碼啟用及隱蔽完成後，即可透過執行rake檔取得指定facebook events資料並自動呈現在平台頁面中，執行方式如下：

```
  $ rails get_event:fb_event_new
```

<h4 id="3.3">3.3 使用notification.rake</h4>
系統中提供進入最後一週黃金決策期時，收藏該活動的所有會員都會再次收到系統自動發送的活動通知就是需要透過該rake執行task自動發送活動日期小於等於7天的活動通知，執行方式如下

```
  $ rails notification:event
```


<h2 id="4">4. 備註</h2>
以下提供實際上線的Web Application
[The Wall - Indie 音樂資訊平台](https://thewall-indiemusic.herokuapp.com/)