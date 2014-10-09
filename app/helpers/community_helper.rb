module CommunityHelper

  ICONS_MAP = {
      article: {publish: 'fa fa-leaf', update: 'fa fa-edit', destroy: 'fa fa-trash-o'},
      cycle: {create: 'fa fa-clipboard', update: 'fa fa-clipboard', destroy: 'fa fa-trash-o'},
      comment: {create: 'fa fa-comment', update: 'fa fa-comment', destroy: 'fa fa-trash-o'},
      gallery: {create: 'fa fa-film', update: 'fa fa-film', destroy: 'fa fa-trash-o'},
      content_base_content: {create: 'fa fa-picture-o', update: 'fa fa-picture-o', destroy: 'fa fa-trash-o'},
      user: {create: 'fa fa-user', reputation_change: 'fa fa-trophy', subscribe:'fa fa-chain', unsubscribe:'fa fa-chain-broken'}
  }

  def public_activity_icon(key)
    class_name, action = key.split('.')
    haml_tag :i, class: ICONS_MAP[class_name.to_sym][action.to_sym]
  end

  def badge_by_name(name)
    mapping = { 'RAFFLE_PARTICIPANT' => 'badges.raffle_participant.title',
                'RAFFLE_WINNER' => 'badges.raffle_winner.title',
                'COMMUNICABLE' => 'badges.communicable.title',
                'COMMENTATOR_1' => 'badges.commentator.1.title',
                'COMMENTATOR_2' => 'badges.commentator.2.title',
                'RATED_COMMENT_1' => 'badges.rated_comment.1.title',
                'RATED_COMMENT_2' => 'badges.rated_comment.2.title',
                'WRITER_1' => 'badges.writer.1.title',
                'WRITER_2' => 'badges.writer.2.title',
                'RATED_ARTICLE_1' => 'badges.rated_article.1.title',
                'RATED_ARTICLE_2' => 'badges.rated_article.2.title',
                'HOLIVAR_1' => 'badges.holivar.1.title',
                'ARTICLE_VIEWS_1' => 'badges.article_views.1.title',
                'ARTICLE_VIEWS_2' => 'badges.article_views.2.title',
                'PART_OF_WHOLE' => 'badges.part_of_whole.title'}
    name = mapping[name] if mapping[name].present?
    Merit::Badge.by_name(name).first
  end
end
