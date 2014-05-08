# Be sure to restart your server when you modify this file.
#
# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered, either to the action user or to the method (or array of
# methods) defined in the +:to+ option.
#
# 'score' method may accept a block which evaluates to boolean
# (recieves the object as parameter)

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      score 1, on: 'comments#vote_up', to: :user

      score -1, on: 'comments#vote_down', to: :user

      score 1, on: 'articles#vote_up', to: :author

      score -1, on: 'articles#vote_down', to: :author

      score 1, on: 'contents#vote_up', model_name: 'Content::BaseContent', to: :author

      score -1, on: 'contents#vote_down', model_name: 'Content::BaseContent', to: :author

      score 10, on: 'contents#approve', model_name: 'Content::BaseContent', to: :author

    end
  end
end