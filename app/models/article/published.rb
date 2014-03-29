class Article::Published < Article::BaseState

  def publish
  end

  def to_changed
    unless stateful.tmpContent != stateful.content
      transition_to(Article::Initial)
    end
  end

  def approve
    if stateful.tmpContent.present?
      prepare_approve
      transition_to(Article::Approved)
      stateful.save!
    end
  end

  def to_garbage
    if stateful.tmpContent.present?
      prepare_approve
      transition_to(Article::Garbage)
      stateful.save!
    end
  end

  def published?
    true
  end

  def is_updated?
    stateful.content.present? && (stateful.tmpContent != stateful.content)
  end

  private

  def prepare_approve
    stateful.content = stateful.tmpContent
    stateful.tmpContent = nil
  end


end
