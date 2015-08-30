module ApplicationHelper
  def medium_form
    haml_tag :div, class: 'row' do
      haml_tag :div, class: 'col-md-6' do
        yield
      end
    end
  end

  def votable_class(action, votable)
    if cannot?(action, votable) || current_user.voted_for?(votable)
      'inactive'
    end
  end

  def votable_title(action, votable)
    action_title = {vote_up: 'повышать', vote_down: 'понижать'}
    required_points = {vote_up: Utils.RANKS[1], vote_down: Utils.RANKS[2]}

    title = action == :vote_up ? 'Понравилсоь' : 'Не понравилось'
    if cannot? action, votable
      title = user_signed_in? ? "Вы не можете #{action_title[action]} рейтинг, пока ваш опыт не достиг #{required_points[action]}" : "Вы должны войти на сайт, чтобы голосовать"
      title = 'Вы не можете голосовать за себя' if votable.author == current_user
    elsif current_user.voted_for?(votable)
      title = 'Вы уже отдали свой голос'
    end
    title
  end
end