class Comment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include PublicActivity::Model

  acts_as_votable

  validates :content, presence: true, length: {minimum: 3, maximum: 2000}

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :unowned, lambda { |user| where('author NOT IN (?)', user.id) }

  delegate :correct_title, to: :commentable, prefix: true, allow_nil: true

  after_create :increment_counter
  before_destroy :decrement_counter

  def short_content
    truncate(content, length: 50, omission: '...')
  end

  def author
    user
  end

  def commentable_author
    commentable.author
  end

  protected

  def increment_counter(direction = :increment)
    klass = commentable_type.constantize

    p klass.column_names.include? 'comments_count'

    if klass.column_names.include? 'comments_count'
      klass.send "#{direction}_counter", 'comments_count', commentable_id
    end
  end

  def decrement_counter
    increment_counter :decrement
  end

end
