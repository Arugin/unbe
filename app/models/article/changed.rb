class Article::Changed < Article::BaseState
  def is_updated?
    true
  end

  def approved?
    true
  end

  def to_changed
  end
end
