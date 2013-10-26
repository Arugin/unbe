#encoding: utf-8
class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::Ownerable
  include Concerns::Randomizable
  include Concerns::Shortable
  include Concerns::Taggable
  include Mongo::Voteable

  is_impressionable

  field :title, type: String
  field :content, type: String
  field :tmpContent, type: String
  field :isPublished, type: Boolean, default: false
  field :isApproved, type: Boolean, default: false
  field :isUpdated, type: Boolean, default: false
  field :baseRating, type: Integer
  field :rating, type: Integer
  field :system_tag, type: Symbol
  field :to_news, type: Boolean, default: false

  belongs_to :article_area
  belongs_to :article_type
  belongs_to :cycle
  has_many :comments, dependent: :restrict, as: :commentable, class_name: 'Comment'

  search_in :title, :tags

  validates :title, presence: true, length: {minimum: 4, maximum: 70}
  validates :tmpContent, length: {maximum: 20000}

  scope :last_news, lambda { |user, params = {}|
    search_for(user,params).any_of({article_type: ArticleType.where({title: "NEWS"}).first},{to_news: true}).order_by([:created_at, :desc]).and({isApproved: true})
  }
  scope :by_area, lambda { |user, params = {}, area|
    search_for(user,params).where(article_area: area).order_by([:created_at, :desc]).and({isApproved: true})
  }
  scope :non_approved, lambda { |user, params = {}|
    search_for(user,params).any_of({isApproved: false},{isUpdated: true}).and({isPublished: true})
  }
  scope :approved, lambda { |user, params = {}|
    search_for(user,params).where({isApproved: true}).order_by([:created_at, :desc])
  }

  scope :random,lambda {
    all.not_in(article_type: ArticleType.where({title: "NEWS"}).first).and({isApproved: true})
  }

  attr_protected :to_news, :baseRating, :isApproved, :rating, :system_tag

  voteable self, :up => +1, :down => -1
  voteable Cycle, :up => +1, :down => -1

  def un_publish
    self.isPublished = false
    self.isUpdated = true
    self.save
  end

  def publish
    self.isPublished = true
    self.save
  end

  def approve
    self.isUpdated = false
    self.isApproved = true
    self.content = self.tmpContent
    self.tmpContent = nil
    self.save
  end

  def tiny_content
    ending = nil
    max_size = 200
    if short_content.size > max_size
      ending = '...'
    end
    "#{short_content[0..max_size]}#{ending}"
  end

  def short_content
    delimiters = ['<p><!-- unbebreak --></p>']
    beginIndex = 0
    endIndex = nil

    delimiters.each do |delimiter|
      endIndex = content.index delimiter

      unless endIndex.nil?
        endIndex += delimiter.length
        break
      end
    end

    if endIndex.nil?
        return content
    end

    return content[beginIndex, endIndex]
  end

end
