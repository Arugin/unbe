class Image < ActiveRecord::Base
  belongs_to :article

  has_attached_file :file,
                    s3_protocol: :https,
                    path:           '/articles/:attachment/:special_id/:style/:filename',
                    storage:        :s3,
                    url:            ':s3_domain_url',
                    s3_credentials: {
                        bucket: ENV['AWS_BUCKET'],
                        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                    },
                    s3_headers: { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
                    styles: {
                        original: ['1920>', :jpg],
                        medium:   ['650>',   :jpg],
                        thumb:    ['212>',    :jpg]
                    },
                    convert_options: { all: '-quality 80 -background white -flatten +matte' }

  validates_attachment_size :file, less_than: 10000.kilobytes, message: t('errors.attachment_size')
  validates_attachment_content_type :file, content_type: /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, message: 'Формат файла неверный'
end
