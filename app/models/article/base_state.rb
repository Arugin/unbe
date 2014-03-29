class Article::BaseState < StatePattern::State
  def publish
    unless stateful.tmpContent.nil?
      transition_to(Article::Published)
      stateful.save!
    end
  end

  def approve
  end

  def to_changed
  end

  def to_garbage
  end

  def published?
    false
  end

  def approved?
    false
  end

  def garbage?
    false
  end

  def is_updated?
    false
  end
end
