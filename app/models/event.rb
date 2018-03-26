class Event < ApplicationRecord

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

  # ransck
  STAGE = {
    'The Wall Live House': 'The Wall Live House',
    'Korner': 'KORNER',
    'Revolver': 'Revolver',
    'PIPE Live Music': 'PIPE Live Music',
    'Legacy 傳 音樂展演空間': 'Legacy',
    '公館河岸留言': '公館河岸留言'
  }

  def get_spotify_data(artist_name)

    if artist_name != nil
      require 'rspotify'
      RSpotify.authenticate("54168cbe8372462f9c62d4e58576f6bc", "c92d63e9f81542c1b65a888cfbb55d70")
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
