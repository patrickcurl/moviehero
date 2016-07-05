# == Schema Information
#
# Table name: featured_movies
#
#  id          :integer          not null, primary key
#  now_playing :boolean          default(FALSE)
#  upcoming    :boolean          default(FALSE)
#  popular     :boolean          default(FALSE)
#  top_rated   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FeaturedMovie < ActiveRecord::Base
  self.inheritance_column = nil

  # has_one :movie, primary_key: "id", foreign_key: "id"
  def self.updateMovies
    self.truncate!
    self.getMovies("now_playing")
    self.getMovies("upcoming")
    self.getMovies("top_rated")
    self.getMovies("popular")
  end

  def self.getMovies(type)
    movies = Tmdb::Movie.send type
    page=1
    total_pages=movies.total_pages
    total_pages.times do
      if page > 1
        movies = Tmdb::Movie.send type, page: page

      end
      movies.results.each do |x|
        @movie = Movie.find_or_create_by(id: x.id)
        @movie.id = x.id
        @movie.title = x.title
        @movie.original_title = x.original_title
        @movie.adult = x.adult
        @movie.overview = x.overview
        @movie.original_language = x.original_language
        @movie.release_date = x.release_date
        @movie.genre_ids = x.genre_ids
        @movie.popularity = x.popularity
        @movie.vote_count = x.vote_count
        @movie.vote_average = x.vote_average
        @movie.poster_path = x.poster_path
        @movie.backdrop_path = x.backdrop_path
        @movie.slug = nil
        # a.videos = Tmdb::Movie.videos(x.id).map{|x| {id: x.id, key: x.key, name: x.name, site: x.site, size: x.size, type: x.type} }
        @movie.save
        @featured = FeaturedMovie.find_or_create_by(id: x.id, type: type)
        @featured.save
      end
      page+=1
    end

  end


  def self.listMovies(type="now_playing")
    return FeaturedMovie.where({type: type})
  end

  def self.getLatest(amount=8, type="now_playing")
    return FeaturedMovie.includes(:movie).where.not(movies: {videos: "[]"}).where.not(movies: {videos: nil}).where(type: type).first(amount)
  end

  def self.truncate!
    connection.execute("truncate table featured_movies")
    connection.reset_pk_sequence!('featured_movies')
  end


end
