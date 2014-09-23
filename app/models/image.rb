class Image
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :article

  has_mongoid_attached_file :file,
                            path:           '/articles/:attachment/:id_partition/:style/:filename',
                            storage:        :s3,
                            url:            ':s3_domain_url',
                            s3_credentials: {
                                bucket: ENV['AWS_BUCKET'],
                                access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                            },
                            styles: {
                                original: ['1920>', :jpg],
                                medium:   ['650>',   :jpg],
                                thumb:    ['212>',    :jpg]
                            },
                            convert_options: { all: '-background white -flatten +matte' }

  validates_attachment_size :file, less_than: 10000.kilobytes, message: I18n.t(:FILE_SIZE_IS_LIMITED)
  validates_attachment_content_type :file, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png)$/, message: I18n.t(:ONLY_IMAGES_CAN_BE_UPLOADED)

end
