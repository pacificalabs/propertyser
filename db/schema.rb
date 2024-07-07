# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_04_034621) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "act_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_act_postcodes_on_locality"
    t.index ["location_id"], name: "index_act_postcodes_on_location_id"
    t.index ["postcode"], name: "index_act_postcodes_on_postcode"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "amenities", force: :cascade do |t|
    t.bigint "apartment_id"
    t.boolean "childcare_centre", default: false
    t.boolean "primary_school", default: false
    t.boolean "high_school", default: false
    t.boolean "bus_stop", default: false
    t.boolean "train_station", default: false
    t.boolean "ferry_wharf", default: false
    t.boolean "park", default: false
    t.boolean "playground", default: false
    t.boolean "golf_course", default: false
    t.boolean "beach", default: false
    t.boolean "gym", default: false
    t.boolean "library", default: false
    t.boolean "light_rail", default: false
    t.boolean "shopping_centre", default: false
    t.boolean "swimming_pool", default: false
    t.boolean "village_shops", default: false
    t.boolean "restaurants", default: false
    t.boolean "cafes", default: false
    t.boolean "grocery_store", default: false
    t.boolean "hospital", default: false
    t.boolean "medical_centre", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_amenities_on_apartment_id"
  end

  create_table "apartments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "location_id"
    t.text "house_number"
    t.text "street_address"
    t.text "suburb"
    t.text "state"
    t.integer "postcode"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.integer "parking_spaces"
    t.integer "land_size"
    t.integer "internal_space"
    t.integer "asking_price"
    t.float "latitude"
    t.float "longitude"
    t.text "description"
    t.bigint "featured_photo_id"
    t.boolean "strata", default: false
    t.boolean "approved", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["latitude", "longitude"], name: "index_apartments_on_latitude_and_longitude"
    t.index ["location_id"], name: "index_apartments_on_location_id"
    t.index ["user_id"], name: "index_apartments_on_user_id"
  end

  create_table "apartments_searches", id: false, force: :cascade do |t|
    t.bigint "apartment_id", null: false
    t.bigint "search_id", null: false
    t.index ["apartment_id", "search_id"], name: "index_apartments_searches_on_apartment_id_and_search_id"
    t.index ["search_id", "apartment_id"], name: "index_apartments_searches_on_search_id_and_apartment_id"
  end

  create_table "apartments_users", id: false, force: :cascade do |t|
    t.bigint "apartment_id", null: false
    t.bigint "user_id", null: false
    t.index ["apartment_id", "user_id"], name: "index_apartments_users_on_apartment_id_and_user_id"
    t.index ["user_id", "apartment_id"], name: "index_apartments_users_on_user_id_and_apartment_id"
  end

  create_table "aus_post_codes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "dc"
    t.string "locality_type"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_aus_post_codes_on_locality"
    t.index ["location_id"], name: "index_aus_post_codes_on_location_id"
    t.index ["postcode"], name: "index_aus_post_codes_on_postcode"
  end

  create_table "banners", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "image"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_banners_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "apartment_id"
    t.bigint "user_id"
    t.text "body"
    t.bigint "comment_id"
    t.bigint "vote_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_comments_on_apartment_id"
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["vote_id"], name: "index_comments_on_vote_id"
  end

  create_table "descriptors", force: :cascade do |t|
    t.bigint "apartment_id"
    t.boolean "airy", default: false
    t.boolean "bright", default: false
    t.boolean "brand_new", default: false
    t.boolean "cosy", default: false
    t.boolean "district_view", default: false
    t.boolean "elegant", default: false
    t.boolean "luxurious", default: false
    t.boolean "original", default: false
    t.boolean "renovated", default: false
    t.boolean "unrenovated", default: false
    t.boolean "spacious", default: false
    t.boolean "water_view", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_descriptors_on_apartment_id"
  end

  create_table "features", force: :cascade do |t|
    t.bigint "apartment_id"
    t.boolean "air_conditioner", default: false
    t.boolean "alarm_system", default: false
    t.boolean "balcony", default: false
    t.boolean "built_in_wardrobe", default: false
    t.boolean "central_heating", default: false
    t.boolean "courtyard", default: false
    t.boolean "dishwasher", default: false
    t.boolean "ensuite", default: false
    t.boolean "floorboards", default: false
    t.boolean "garage", default: false
    t.boolean "home_gym", default: false
    t.boolean "outdoor_area", default: false
    t.boolean "outdoor_spa", default: false
    t.boolean "secure_parking", default: false
    t.boolean "shed", default: false
    t.boolean "swimming_pool", default: false
    t.boolean "tennis_court", default: false
    t.boolean "wine_cellar", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_features_on_apartment_id"
  end

  create_table "floorplans", force: :cascade do |t|
    t.bigint "apartment_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_floorplans_on_apartment_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "alias_name"
    t.float "lat"
    t.float "long"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "search_id"
    t.index ["search_id"], name: "index_locations_on_search_id"
  end

  create_table "locations_searches", id: false, force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "search_id", null: false
    t.index ["location_id", "search_id"], name: "index_locations_searches_on_location_id_and_search_id"
    t.index ["search_id", "location_id"], name: "index_locations_searches_on_search_id_and_location_id"
  end

  create_table "market_ratings", force: :cascade do |t|
    t.integer "suggested_price"
    t.bigint "apartment_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_market_ratings_on_apartment_id"
    t.index ["user_id"], name: "index_market_ratings_on_user_id"
  end

  create_table "nsw_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_nsw_postcodes_on_locality"
    t.index ["location_id"], name: "index_nsw_postcodes_on_location_id"
    t.index ["postcode"], name: "index_nsw_postcodes_on_postcode"
  end

  create_table "nt_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_nt_postcodes_on_locality"
    t.index ["location_id"], name: "index_nt_postcodes_on_location_id"
    t.index ["postcode"], name: "index_nt_postcodes_on_postcode"
  end

  create_table "photo_descriptions", force: :cascade do |t|
    t.text "description"
    t.boolean "featured", default: false
    t.integer "photo_id"
    t.bigint "apartment_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_photo_descriptions_on_apartment_id"
    t.index ["photo_id"], name: "index_photo_descriptions_on_photo_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "apartment_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_photos_on_apartment_id"
  end

  create_table "property_milestones", force: :cascade do |t|
    t.bigint "apartment_id"
    t.boolean "first_property_uploaded", default: false
    t.boolean "congratulated_on_first_property_uploaded", default: false
    t.boolean "property_uploaded", default: false
    t.boolean "congratulated_on_property_uploaded", default: false
    t.string "type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["apartment_id"], name: "index_property_milestones_on_apartment_id"
  end

  create_table "qld_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_qld_postcodes_on_locality"
    t.index ["location_id"], name: "index_qld_postcodes_on_location_id"
    t.index ["postcode"], name: "index_qld_postcodes_on_postcode"
  end

  create_table "sa_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_sa_postcodes_on_locality"
    t.index ["location_id"], name: "index_sa_postcodes_on_location_id"
    t.index ["postcode"], name: "index_sa_postcodes_on_postcode"
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "user_id"
    t.string "query"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "tas_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_tas_postcodes_on_locality"
    t.index ["location_id"], name: "index_tas_postcodes_on_location_id"
    t.index ["postcode"], name: "index_tas_postcodes_on_postcode"
  end

  create_table "user_milestones", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "sent_welcome_letter", default: false
    t.boolean "email_address_confirmed", default: false
    t.boolean "updated_phone_number", default: false
    t.boolean "updated_email", default: false
    t.boolean "updated__username", default: false
    t.boolean "reset_password", default: false
    t.string "type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_user_milestones_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "username"
    t.string "firstname"
    t.string "surname"
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "password_token_valid_until", precision: nil
    t.datetime "last_search_query_match", precision: nil
    t.boolean "is_admin", default: false
    t.boolean "accepted_terms_and_conditions", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vic_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_vic_postcodes_on_locality"
    t.index ["location_id"], name: "index_vic_postcodes_on_location_id"
    t.index ["postcode"], name: "index_vic_postcodes_on_postcode"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "comment_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["comment_id"], name: "index_votes_on_comment_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "wa_postcodes", force: :cascade do |t|
    t.integer "postcode"
    t.string "locality"
    t.string "state"
    t.float "lat"
    t.float "long"
    t.string "status"
    t.bigint "location_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["locality"], name: "index_wa_postcodes_on_locality"
    t.index ["location_id"], name: "index_wa_postcodes_on_location_id"
    t.index ["postcode"], name: "index_wa_postcodes_on_postcode"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "banners", "users"
  add_foreign_key "locations", "searches"
end
