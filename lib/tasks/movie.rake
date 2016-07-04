namespace :movie do
  desc "TODO"
  task import: :environment do

    #movie_id, title, original_title, adult, overview, original_language, release_date, genre_ids, popularity, vote_count, vote_average, poster_path, backdrop_path, details, videos, posters, reviews, keywords
    movies = Tmdb::Discover.movie
    page=1
    total_pages=movies.total_pages
    total_pages.times do
      if page > 1
        movies = Tmdb::Discover.movie(page: page)
      end
      movies.results.each do |x|
        @movie = Movie.find_or_create_by(movie_id: x.id)
        @movie.movie_id = x.id
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
        # a.videos = Tmdb::Movie.videos(x.id).map{|x| {id: x.id, key: x.key, name: x.name, site: x.site, size: x.size, type: x.type} }
        @movie.save
      end
      page+=1
    end
  end

  task videos: :environment do
    #@movies  = Movie.where("videos is NULL")
    @movies = Movie.where(videos: [nil, "[]"]).all
    @count = @movies.count()
    @movies.each do |x|
      x.videos = Tmdb::Movie.videos(x.movie_id).map{|x| {id: x.id, key: x.key, name: x.name, site: x.site, size: x.size, type: x.type} }
      x.save
      if(@count %40 == 0) then
        sleep 3.2
      end
      puts @count
      @count -= 1
    end
  end

  task details: :environment do
    @movies  = Movie.where("movie_id = 246655")
    @count = @movies.count()
    @movies.each do |x|
      @details = Tmdb::Movie.detail(x.movie_id)
      puts @companies
      x.details = {
        "imdb_id": @details.imdb_id,
        "production_companies": @details.production_companies.map{|p|
            {
              name: p.name,
              id: p.id
            }
        },
        "production_countries": @details.production_countries.map{|c|
          {
            iso_3166_1: c.iso_3166_1,
            name: c.name
          }
        },
        "release_date": @details.release_date,
        "revenue": @details.revenue,
        "runtime": @details.runtime,
        "status": @details.status,
        "tagline": @details.tagline,
        "vote_average": @details.vote_average,
        "vote_count": @details.vote_count,
        "genres": @details.genres.map{|g|
          {
            id: g.id,
            name: g.name
          }
        },
        "homepage": @details.homepage,
        "title": @details.title,
        "budget": @details.budget


      }
      x.save
      sleep 1
      puts @count
      @count -= 1
    end
  end


end
