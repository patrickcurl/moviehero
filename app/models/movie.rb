# == Schema Information
#
# Table name: movies
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  slug       :string
#  data       :jsonb
#  videos     :jsonb
#  posters    :jsonb
#  backdrops  :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Movie < ActiveRecord::Base
extend FriendlyId
friendly_id :title_and_id, use: :slugged
validates_presence_of :title, :slug
has_many :movies_genres, class_name: "MovieGenre"
has_many :genres, through: :movies_genres
has_many :movies_keywords, class_name: "MovieKeyword"
has_many :keywords, through: :movies_keywords
has_many :movies_reviews, class_name: "MovieReview"
has_many :reviews, through: :movies_reviews
scope :title_like, -> (title) { where("title ilike ?", title)}
  def title_and_id
    "#{title} #{id}"
  end
  def self.search(type, field, value)
    if type == "genres" then
      #self.where()
      f = field.to_s
      if !value.is_a? Integer then
        value = "\"#{value}\""
      end
      Movie.where("genres @> ?", "[{\"#{field}\":#{value}}]")
    end
  end
  def self.apiCall(path)
    begin
      eval(path)
    rescue Tmdb::Error => e
      if e.message.include? "is over the allowed limit" then
        retry
        #sleep 1
      end

    end
  end
  # def should_generate_new_friendly_id?
  #   new_record?
  # end
  # get trailer for existing movie via
  def self.getTrailerMid(id)
    vids = Tmdb::Movie.videos(id)
    sleep(2)
    vids.each do |x|
      if x.type == "Trailer" then
        return {
          id: x.id,
          name: x.name,
          key: x.key,
          site: x.site,
          size: x.size,
          type: x.type
        }
      else
        return {
          id: vids.first.id,
          name: vids.first.name,
          key: vids.first.key,
          site: vids.first.site,
          size: vids.first.size,
          type: vids.first.type
        }
      end
    end
  end

  def getTrailer
    vids = self.getVids
    vids.each do |x|
      if x["type"] == "Trailer" then
        return x
      end
    end
    if vids.count > 0 then
      return vids[0]
    else
      return nil
    end
  end

  def getVids
    if self.videos == nil || self.videos == [] then
      vids = Tmdb::Movie.videos(self.movie_id)
      sleep(2)
      @v = []
      vids.each_with_index do |x,i|
        @v[i] =  {
          "id": x.id,
          "key": x.key,
          "name": x.name,
          "site": x.site,
          "size": x.size,
          "type": x.type
        }
      end
      self.videos = @v
      self.save
    else
      @v = self.videos
    end

    return @v
  end

  def getPoster(size)
    base_url = "https://image.tmdb.org/t/p/"
    if self.poster_path then
      return base_url + size + self.poster_path
    else
      return nil
    end
  end

  def getBackdrop(size)
    base_url = "https://image.tmdb.org/t/p/"
    if self.backdrop_path then
      return base_url + size + self.backdrop_path
    else
      return nil
    end
  end

  def self.import(id)
    begin
      m = Movie.where(id: id).first_or_create
      return m.importData
    rescue
      return nil
    end
    #return m
  end

  def importData
    begin
      data = Movie.apiCall("Tmdb::Movie.detail(#{self.id}, append_to_response:'images,videos,keywords,credits,reviews')").each_pair{|x,y| {x:y}}
    rescue
      return nil
    end
    # media = {
    #   posters: data[:images].posters,
    #   backdrops: data[:images].backdrops,
    #   videos: data[:videos].results
    # }
    # # return media

    self.id = data[:id]
    self.title = data[:title]
    # return data[:genres]
    begin
      self.data = data.reject{|x|
                    [:videos,:images,:credits,:belongs_to_collection,
                     :genres,:keywords,:production_companies,:spoken_languages,
                     :production_countries, :reviews].include?(x)
                  }
    rescue
      nil
    end
    begin
    self.reviews = data[:reviews].results.map{|x|
        #begin
          Review.where(
                      tmdb_id: x.id, #tmdb review id
                      author_name: x.author,
                      movie_id: self.id, #tmdb movie id / local movie id
                      content: x.content,
                      url: x.url
                    ).first_or_create
        #rescue
        #  nil
        #end
       }.reject{|x| x.nil?}
    rescue
      nil
    end
    begin
    self.genres = data[:genres].map{|x|
      #begin
        Genre.where(
          id: x.id, name: x.name
        ).first_or_create
      #rescue
      #  nil
      #end
    }.reject{|x| x.nil?}
    #return data[:keywords]
    rescue
      nil
    end
    begin
    self.keywords = data[:keywords].keywords.map{|x|
      #begin
        Keyword.where(
          id: x.id, name: x.name
        ).first_or_create
      #rescue
      #  nil
      #end
    }.reject{|x| x.blank?}
    rescue
      nil
    end

    # import images as they share same structure
    [:posters, :backdrops].each do |x|
      media = data[:images].send(x.to_s).map{|x| x.each_pair{|k,v| [k:v]}}.reject{|x| x.nil?}
      self.send("#{x.to_s}=", media)
    end
    # import videos/trailers
    self.videos = data[:videos].results.map{|x| x.each_pair {|k,v| [k: v]
     }}.reject{|x| x.nil? }

    self.slug = nil

    # Create / Attach Genres and Keywords
    # [:genres, :keywords].each do |new_obj|
    #   # if !data[new_obj].blank?
    #     new_data = data[new_obj].map{|x|
    #       if !x.blank? then
    #         model = new_obj.to_s.titleize.singularize
    #         Object.const_get(model).find_or_create_by(id: x.id, name: x.name)
    #         #Genre.find_or_create_by(id: x.id, name: x.name)
    #       else
    #         nil
    #       end
    #     }.reject{|x| x.nil?}
    #     self.send("#{new_obj.to_s}=", new_data)
    #   end
    # end
    #
    # if !data[:reviews].results.blank?
    #
    #   self.reviews = Review.multipageInsert(data[:reviews])
    #
    #   #self.send("#{new_obj.to_s}=", new_data)
    # end





    # make sure keywords aren't nil, or we get Nilclass error on setting the record.
    # if !data[:keywords].blank?
    #   self.keywords = data[:keywords].keywords.map{|x|
    #       if !x.blank? then
    #         Keyword.find_or_create_by(id: x.id, name: x.name)
    #       else
    #         nil
    #       end
    #     }.reject{|x| x.nil?}
    # end
    # return keywords
    #qself.keywords = keywords unless keywords.blank?
    self.save
    return self
  end
  def importCredits
    data = Movie.apiCall("Tmdb::Movie.detail(#{self.id}, append_to_response:'credits')")
    #cast = data[:credits].cast.map{|x| x.each_pair{|k,v| [k:v]}}.reject{|x| x.nil?}
    cast = data.credits.cast.map{|x| x.each_pair{|k,v| [k:v]}}.reject{|x| x.nil?}
    crew = data.credits.crew.map{|x| x.each_pair{|k,v| [k:v]}}.reject{|x| x.nil?}
    #return cast
    return cast
    movie_id = self.id
    cast.each do |x|

      #return x.reject{|x| [:credit_id].include?(x)}
      #begin
      # if !x[:character].blank? 
      #   return x[:character]
      # end 
     begin
        pdata = Movie.apiCall("Tmdb::Person.detail(#{x[:id]})").each_pair{|k,v| [k:v]}
        #return pdata[:imdb_id]

        person = Person.where(id: pdata[:id], imdb_id: pdata[:imdb_id], name: pdata[:name]).first_or_create
        person.data = pdata.reject{|x| [:id, :imdb_id, :name].include?(x)}
      
        person.save
        if !person.blank? then
          credit = Credit.where(id: x[:credit_id], movie_id: self.id, person_id: person.id).first_or_create
        end
        [:cast_id, :department, :job, :character, :name, :order, :profile_path, :type].each do |y|
          #return x[y]
          begin
            creditProp = y
            credit.send("#{y}=", x[:y])
          rescue
            nil
          end 
        end
        credit.save
        #return credit
     rescue
      nil
     end
      #credit.cast_id = x[:cast_id]
      #credit.department = x[:department]
      # t.string  :id, null: false
      # t.integer :movie_id, null: false
      # t.integer :person_id, null: false
      # t.integer :cast_id
      # t.string :department
      # t.string :job
      # t.string :character
      # t.string :name
      # t.integer :order
      # t.string :profile_path
      # t.string :type #cast/crew
      # t.string :slug
      # t.timestamps null: false
      
      #return person_data
      #.map{|x| x.each_pair{|k,v| [k:v]}}
      #return person_data
      #person = Person.where(id: pdata.)
    end

  end
  def mapVideos(data)
    videos = data
  end


  def self.updateVideos
    @movies = Movie.where(videos: [nil, "[]"]).all
    # @count = @movies.count()
    @movies.each do |x|
      sleep 0.10
      videos = Movie.apiCall("Tmdb::Movie.videos(#{x.movie_id})")

      if !videos.empty? then
        p videos
        x.videos = videos.map{|x|
                  {
                    id: x.id,
                    key: x.key,
                    name: x.name,
                    site: x.site,
                    size: x.size,
                    type: x.type
                  }
                }

        x.save
      else
        x.videos = nil
        x.save
      end
    end
    return Movie.where(videos: [nil, "[]"]).all
  end
  def getCredits
      types = ["cast", "crew", "director"]
      types.each do |t|
        roles = self.getCredit(t)
        roles.each do |x|
          credit = Credit.find_or_create_by(credit_id: x.credit_id)
          credit.movie_id = self.id
          credit.person_id = x.id
          credit.cast_id = x.cast_id.blank? ? nil : x.cast_id
          credit.credit_id = x.credit_id.blank? ? nil : x.credit_id
          credit.credit_type = t
          credit.character = x.character.blank? ? nil : x.character
          credit.name = x.name.blank? ? nil : x.name
          credit.order = x.order.blank? ? nil : x.order
          credit.profile_path = x.profile_path.blank? ? nil : x.profile_path
          credit.department = x.department.blank? ? nil : x.department
          credit.job = x.job.blank? ? nil : x.job
          credit.media_type = x.media_type.blank? ? nil : x.media_type
          credit.title = x.title.blank? ? nil : x.title
          credit.release_date = x.date.blank? ? nil : x.date
          credit.poster_path = x.poster_path.blank? ? nil : x.poster_path
          credit.save
          # if(!Person.exists?(x.id)) then
          #  Person.find_or_create_by()
          # end
        end
      end
  end
  def getCredit(type)
    Tmdb::Movie.send type, self.id
  end



  def self.truncate!
    connection.execute("truncate table movies")
    connection.reset_pk_sequence!('movies')
  end

end
