#encoding: utf-8
class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Concerns::Searchable

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

  search_in :title

  scope :last_news, where(:article_type => ArticleType.where({:title => "NEWS"}).first).order_by([:created_at, :desc])

end
