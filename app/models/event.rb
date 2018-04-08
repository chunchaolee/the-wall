class Event < ApplicationRecord
  serialize :artist_array, Array
  serialize :artists_id_array, Array

  # 欄位驗證 :artist_name待補
  validates_presence_of :title, :date, :time, :stage

  # 一個event可以有很多筆被interest的資料
  has_many :interests, dependent: :destroy
  # 一個event可以被很多user interest
  has_many :interested_users, through: :interests, source: :user

  # 一個event可以有很多筆被view的資料
  has_many :views, dependent: :destroy
  # 一個event可以被很多user view
  has_many :viewed_users, through: :views, source: :user

  # 一個event可以有很多筆要notification的資料
  has_many :notifications, dependent: :destroy
  # 一個event可以對很多user送出notification
  has_many :notified_users, through: :notifications, source: :user

  # 一個活動目前設定只會顯示一筆藝人資料
  belongs_to :artist, optional: true

  # ransck
  STAGE = {
    'The Wall Live House': 'The Wall Live House',
    'Korner': 'Korner',
    'Revolver': 'Revolver',
    'PIPE Live Music': 'PIPE Live Music',
    'Legacy mini @ amba': 'Legacy mini @ amba',
    'Legacy 傳 音樂展演空間': 'Legacy 傳 音樂展演空間',
    '永豐 Legacy Taipei 音樂展演空間': '永豐 Legacy Taipei 音樂展演空間',
    'Legacy Taichung': 'Legacy Taichung',
    '公館河岸留言': '公館河岸留言',
    '河岸留言 音樂藝文咖啡': '河岸留言 音樂藝文咖啡',
    '台北 月見ル君想フ': '台北 月見ル君想フ'
  }

  CITY = {
    'Taichung': '台中',
    'Taipei': '台北',
  }


  def get_spotify_data(artist_name)

    if artist_name != nil
      require 'rspotify'

      if Rails.env.development?
        # local用
        spotify_config = Rails.application.config_for(:spotify)
        client_id = spotify_config["client_id"]
        client_secret = spotify_config["client_secret"]
      elsif Rails.env.production?
        # heroku用
        client_id = ENV['SPOTIFY_CLIENT_ID']
        client_secret = ENV['SPOTIFY_CLIENT__SECRET']
      end

      RSpotify.authenticate("#{client_id}", "#{client_secret}")
      artist = RSpotify::Artist.search(artist_name)
      artist_data = artist.first
    end

  end

  def load_spotify_artist_id(event)
    if event.spotify_artist_id == nil
      spotify_data = event.get_spotify_data(event.artist_name)
      if spotify_data == nil
        event.spotify_artist_id = nil
      else
        event.spotify_artist_id = spotify_data.id
        event.save
      end
    end
  end

  def count_views
    self.views_count += 1
    self.save
  end

end
