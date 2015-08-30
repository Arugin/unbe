module Paperclip::Interpolations
  def special_id(attachment, style_name)
    old_id = attachment.instance.old_id
    if old_id.present?
      old_id.scan(/.{4}/).join("/")
    else
      id_partition(attachment, style_name)
    end
  end
end