class Article::Garbage < Article::BaseState
  def approved?
    true
  end

  def garbage?
    true
  end

  def published?
    true
  end
end
