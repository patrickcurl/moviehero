# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160630235833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credits", force: :cascade do |t|
    t.integer  "movie_id",     null: false
    t.integer  "person_id",    null: false
    t.integer  "cast_id"
    t.string   "department"
    t.string   "job"
    t.string   "character"
    t.string   "name"
    t.integer  "order"
    t.string   "profile_path"
    t.string   "type"
    t.string   "slug"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "credits", ["movie_id"], name: "index_credits_on_movie_id", using: :btree
  add_index "credits", ["person_id"], name: "index_credits_on_person_id", using: :btree
  add_index "credits", ["slug"], name: "index_credits_on_slug", unique: true, using: :btree

  create_table "featured_movies", force: :cascade do |t|
    t.boolean  "now_playing", default: false
    t.boolean  "upcoming",    default: false
    t.boolean  "popular",     default: false
    t.boolean  "top_rated",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "genres", ["name"], name: "index_genres_on_name", unique: true, using: :btree
  add_index "genres", ["slug"], name: "index_genres_on_slug", unique: true, using: :btree

  create_table "keywords", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", unique: true, using: :btree
  add_index "keywords", ["slug"], name: "index_keywords_on_slug", unique: true, using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "slug"
    t.jsonb    "data"
    t.jsonb    "videos"
    t.jsonb    "posters"
    t.jsonb    "backdrops"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "movies", ["backdrops"], name: "index_movies_on_backdrops", using: :gin
  add_index "movies", ["data"], name: "index_movies_on_data", using: :gin
  add_index "movies", ["posters"], name: "index_movies_on_posters", using: :gin
  add_index "movies", ["slug"], name: "index_movies_on_slug", unique: true, using: :btree
  add_index "movies", ["videos"], name: "index_movies_on_videos", using: :gin

  create_table "movies_genres", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "genre_id", null: false
  end

  add_index "movies_genres", ["genre_id"], name: "index_movies_genres_on_genre_id", using: :btree
  add_index "movies_genres", ["movie_id"], name: "index_movies_genres_on_movie_id", using: :btree

  create_table "movies_keywords", force: :cascade do |t|
    t.integer "movie_id",   null: false
    t.integer "keyword_id", null: false
  end

  add_index "movies_keywords", ["keyword_id"], name: "index_movies_keywords_on_keyword_id", using: :btree
  add_index "movies_keywords", ["movie_id"], name: "index_movies_keywords_on_movie_id", using: :btree

  create_table "movies_reviews", force: :cascade do |t|
    t.integer "movie_id",  null: false
    t.integer "review_id", null: false
  end

  add_index "movies_reviews", ["movie_id"], name: "index_movies_reviews_on_movie_id", using: :btree
  add_index "movies_reviews", ["review_id"], name: "index_movies_reviews_on_review_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.integer  "imdb_id"
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "people", ["data"], name: "index_people_on_data", using: :gin
  add_index "people", ["imdb_id"], name: "index_people_on_imdb_id", unique: true, using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree
  add_index "people", ["slug"], name: "index_people_on_slug", unique: true, using: :btree

  create_table "reviews", force: :cascade do |t|
    t.string   "author_name"
    t.text     "content"
    t.string   "url"
    t.integer  "movie_id",    null: false
    t.integer  "user_id"
    t.string   "tmdb_id"
    t.string   "imdb_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reviews", ["imdb_id"], name: "index_reviews_on_imdb_id", using: :btree
  add_index "reviews", ["movie_id"], name: "index_reviews_on_movie_id", using: :btree
  add_index "reviews", ["tmdb_id"], name: "index_reviews_on_tmdb_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
