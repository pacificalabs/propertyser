class SaveSearchResultsJob
  def self.perform(user:, apartments_collection:, search_query:, search_title:, postcode_list:)
    Thread.new do
      begin
        Rails.logger.info("#{search_query}")
        save_search_result(
          user: user,
          apartments_collection: apartments_collection,
          search_query: search_query,
          search_title: search_title,
          postcode_list: postcode_list
        )
      rescue => e
        Rails.logger.error("Error saving search results: #{e.message}")
      end
    end
  end

  def self.save_search_result(user:, apartments_collection:, search_query:, search_title:, postcode_list:)
    location_list = []
    s1 = Search.find_or_initialize_by(query: search_query.to_s)
    s1.title = search_title if search_title.present?
    s1.user = user if user.present?
    s1.results << apartments_collection if apartments_collection.present?

    if postcode_list.present?
      postcode_list.each do |a|
        location = Location.find_or_create_by(
          name: "#{a.locality} #{a.postcode}",
          state: a.state
        )
        location.aus_post_codes << a
        location_list << location
      end
      s1.locations << location_list
    end

    s1.query = search_query
    s1.save!
  end
end
