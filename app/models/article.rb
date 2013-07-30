class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :tmpContent, type: String
  field :isPublished, type: Boolean
  field :isApproved, type: Boolean
  field :isUpdated, type: Boolean
  field :baseRating, type: Integer
  field :rating, type: Integer

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle
end
