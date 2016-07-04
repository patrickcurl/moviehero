json.array!(@movies) do |movie|
  json.extract! movie, :id, :movie_id, :title, :adult, :genre_ids, :movie_data
  json.url movie_url(movie, format: :json)
end
