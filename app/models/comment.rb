class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable
  include ActionView::Helpers::TextHelper

  field :content, type: String

  validates :content, presence: true, length: {minimum: 3, maximum: 1000}

  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user

  default_scope order_by(created_at: :asc)

  scope :unowned, lambda { |user|
    not_in(author: user.id)
  }

  voteable self, up: +1, down: -1

  def short_content
    truncate(content, length: 50, omission: '...')
  end

  def commentable_author
    commentable.author
  end

end
