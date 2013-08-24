class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :imageable, polymorphic: true

  has_mongoid_attached_file :file,
                            :path           => '/:class/:attachment/:id_partition/:style/:filename',
                            :storage        => :s3,
                            :url            => ':s3_domain_url',
                            :s3_credentials => {
                                :bucket => ENV['AWS_BUCKET'],
                                :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                                :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                            },
                            :styles => {
                                :original => ['1920x1680>', :jpg],
                                :small    => ['100x100>',   :jpg],
                                :medium   => ['250x250',    :jpg],
                                :large    => ['500x500>',   :jpg],
                                :mini     => ['50x50>',   :jpg],
                            },
                            :convert_options => { :all => '-background white -flatten +matte' }
  attr_accessible :file
  validates_attachment_size :file, :less_than => 200.kilobytes, :message => I18n.t(:FILE_SIZE_IS_LIMITED)
  validates_attachment_content_type :file, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png)$/, :message => I18n.t(:ONLY_IMAGES_CAN_BE_UPLOADED)

end
