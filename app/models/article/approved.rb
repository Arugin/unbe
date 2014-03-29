class Article::Approved < Article::BaseState

  def publish
  end

  def to_changed
    if stateful.tmpContent != stateful.content
      transition_to(Article::Changed)
    else
      stateful.tmpContent = nil
    end
    stateful.save!
  end

  def published?
    true
  end

  def approved?
    true
  end
end
