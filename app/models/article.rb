class Article < ActiveRecord::Base
  extend FriendlyId
  require 'nokogiri'

  friendly_id :title, use: [:slugged, :history, :finders]

  has_many :images, dependent: :destroy


end
