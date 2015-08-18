class Comment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include PublicActivity::Model

  acts_as_votable

  validates :content, presence: true, length: {minimum: 3, maximum: 2000}

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :unowned, lambda { |user|
    not_in(author: user.id)
  }

  delegate :correct_title, to: :commentable, prefix: true, allow_nil: true

  def short_content
    truncate(content, length: 50, omission: '...')
  end

  def author
    user
  end

  def commentable_author
    commentable.author
  end

end
