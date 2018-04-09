class Artist < ApplicationRecord
  
  require 'rspotify'

  validates_presence_of :name
  validates_uniqueness_of :name
  # 一個藝人可以有很多活動
  has_many :events

  def get_spotify_data

    artist_name = self.name
    return if artist_name.blank?

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
