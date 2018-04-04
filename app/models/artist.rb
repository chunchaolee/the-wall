class Artist < ApplicationRecord
  validates_presence_of :name
  # 一個藝人可以有很多活動
  has_many :events

  def get_spotify_data(artist_name)

    if artist_name != nil
      require 'rspotify'
      RSpotify.authenticate("54168cbe8372462f9c62d4e58576f6bc", "c92d63e9f81542c1b65a888cfbb55d70")
      artist = RSpotify::Artist.search(artist_name)
      artist_data = artist.first
    end

  end

end
