module Content
  class VideoContent < Content::BaseContent

    def self.size
      {normal: { width:"420", height:"315" }}
    end

  end
end