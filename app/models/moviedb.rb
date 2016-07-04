class Moviedb

  def self.testmeth
    "this test sucks"
  end



  def self.call(path)
    begin
      eval(path)
    rescue Tmdb::Error => e
      if e.message.include? "is over the allowed limit" then
        retry
        #sleep 1
      end

    end
   end

  def self.test
    a = []
    100.times do |x|
      a[x] = Moviedb.call("Tmdb::Movie.detail(#{x}).title")
      if !a[x].blank? then
        puts a[x]
      else
        next
      end
    end
    return a.reject{|x,y|x.nil?}
  end
end
