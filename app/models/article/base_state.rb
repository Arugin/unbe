class Article::BaseState < StatePattern::State
  def publish
    unless stateful.tmpContent.blank?
      transition_to(Article::Published)
      stateful.save!
      stateful
    else
      stateful.errors
    end
  end

  def approve
  end

  def to_changed
    if stateful.tmpContent != stateful.content
      transition_to(Article::Changed)
    else
      stateful.tmpContent = nil
    end
    stateful.save!
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
