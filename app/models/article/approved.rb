class Article::Approved < Article::BaseState

  def publish
  end

  def published?
    true
  end

  def approved?
    true
  end
end
