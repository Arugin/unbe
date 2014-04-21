module CommunityHelper

  ICONS_MAP = {
      article: {publish: 'fa fa-leaf', update: 'fa fa-edit', destroy: 'fa fa-trash-o'},
      cycle: {create: 'fa fa-clipboard', update: 'fa fa-clipboard', destroy: 'fa fa-trash-o'},
      comment: {create: 'fa fa-comment', update: 'fa fa-comment', destroy: 'fa fa-trash-o'},
      gallery: {create: 'fa fa-film', update: 'fa fa-film', destroy: 'fa fa-trash-o'},
      content_base_content: {create: 'fa fa-picture-o', update: 'fa fa-picture-o', destroy: 'fa fa-trash-o'},
      user: {create: 'fa fa-user', reputation_change: 'fa fa-trophy'}
  }

  def public_activity_icon(key)
    class_name, action = key.split('.')
    haml_tag :i, class: ICONS_MAP[class_name.to_sym][action.to_sym]
  end

  def badge_by_name(name)
    Merit::Badge.by_name(name).first
  end
end
