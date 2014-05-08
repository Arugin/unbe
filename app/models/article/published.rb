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
      grant_points
      create_activity
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

  def create_activity
    if stateful.content.nil?
      stateful.create_activity action: :publish, owner: Proc.new{ |controller, model| controller.current_user if controller.present? }
    else
      stateful.create_activity action: :update, owner: Proc.new{ |controller, model| controller.current_user if controller.present? }
    end
  end

  def grant_points
    if stateful.content.nil?
      stateful.author.add_points(50)
    end
  end

  def prepare_approve
    stateful.content = stateful.tmpContent
    stateful.tmpContent = nil
  end


end
