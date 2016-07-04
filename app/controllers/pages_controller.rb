class PagesController < ApplicationController
  autocomplete :movie, :title
  def home
    #@np = FeaturedMovie.where({type: "now_playing", videos: {!nil, ![]}}).first(8)
    @np = FeaturedMovie.getLatest(8, "now_playing")
    # @upcoming = FeaturedMovie.where({type: "upcoming"}).first(8)
    @upcoming = FeaturedMovie.getLatest(8, "upcoming")
    #@top_rated = FeaturedMovie.where({type: "top_rated"}).first(8)
    @top_rated = FeaturedMovie.getLatest(8, "top_rated")
    #@popular = FeaturedMovie.where({type: "popular"}).first(8)
    @popular = FeaturedMovie.getLatest(8, "popular")
    # config = Tmdb::Configuration.get
    # @base_url = config.images.secure_base_url
    # @message = "this is a test"
  end
end
