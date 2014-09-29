class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable
  include ActionView::Helpers::TextHelper
  include PublicActivity::Model

  field :content, type: String

  validates :content, presence: true, length: {minimum: 3, maximum: 2000}

  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user

  default_scope lambda {
    order_by(created_at: :asc)
  }

  scope :unowned, lambda { |user|
    not_in(author: user.id)
  }

  delegate :correct_title, to: :commentable, prefix: true, allow_nil: true

  voteable self, up: +1, down: -1

  def short_content
    truncate(content, length: 50, omission: '...')
  end

  def commentable_author
    commentable.author
  end

end
