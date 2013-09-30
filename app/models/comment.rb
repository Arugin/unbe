class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongo::Voteable

  field :content, type: String

  validates :content, presence: true, length: {minimum: 3, maximum: 1000}

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  voteable self, :up => +1, :down => -1

  def short_content
    if self.content.size > 40
      "#{self.content[0..40]}..."
    else
      self.content
    end
  end
end
