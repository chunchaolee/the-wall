class ArtistsController < ApplicationController

  before_action :set_artist, only: [:show]

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

end
