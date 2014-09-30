class Article::Initial < Article::BaseState

  def publish
    unless stateful.tmpContent.blank?
      transition_to(Article::Published)
      stateful.created_at = Time.now
      stateful.save!
      stateful
    else
      stateful.errors
    end
  end

  def to_changed
  end

end
