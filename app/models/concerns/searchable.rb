module Searchable

  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
      
    pg_search_scope :akin_to,
    against: :locality,
    using: :trigram

  end
  
end