module Content
  class VideoContent < Content::BaseContent

    field :src, type: String

    def self.size
      {normal: { width:"420", height:"315" }}
    end

  end
end