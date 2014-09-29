module ArticlesHelper
  def item_count_title(author, action, item_type)
    "#{sex_action(author, action)} #{count_items(author, item_type)}"
  end

  def count_items(author, item_type)
    items = {cycles: ['цикл','цикла','циклов'],
             articles: ['статью','статьи', 'статей'],
             comments: ['комментарий','комментария','комментариев'],
             subscribers: ['подписчика','подписчиков','подписчиков']
    }
    size = author.send(item_type).size
    "#{size} #{Russian::pluralize(size, *items[item_type])}"
  end

  def sex_action(author, action)
    actions = {create: ['создала', 'создал'], comment: ['оставила','оставил'], have:['очаровала','очаровал'], publish:['опубликовала','опубликовал']}
    author.female? ?  actions[action][0] : actions[action][1]
  end
end
