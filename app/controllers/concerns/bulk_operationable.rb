# Adds bulk functionality to controller
#
# Should be initialized after include, in example:
#
#     include Concerns::BulkOperationable
#     bulk_actions :delete, :tag, :export
#
# Depends on proper controller and routes naming, in example:
#   ProjectsController relate to Project model, projects_path exist
#
# Export bulk action use 'archive' model method to get archive of each file
# Tag bulk action rely on Taggable model concern or custom add_tags implementation

module Concerns
  module BulkOperationable
    extend ActiveSupport::Concern

    included do
      def model_name
        controller_name.classify
      end

      def model
        model_name.constantize
      end

      def index_path
        Rails.application.routes.url_helpers.send("#{model_name.downcase.pluralize}_office_path")
      end

      def self.bulk_actions(*actions)
        actions.each { |action| self.send(:include, "Concerns::Bulk#{action.to_s.capitalize}".constantize) }
      end
    end

    private

    def handle_authorize(action, object)
      if cannot? action, object
        "You are not allowed to #{action.to_s} #{model_name.downcase} '#{object.title}' because it does not belong to you"
      else
        false
      end
    end

    def handle_object_delete(object)
      message = "Unable to delete #{model_name.downcase} '#{object.title}': "
      begin
        unless object.destroy
          message += object.errors.full_messages.join(', ')
          return message
        end

      rescue Exception => e
        message += e.message
        return message

      end
      return false
    end

    def notice_helper(count, action)
      if count > 0
        "#{ActionController::Base.helpers.pluralize(
            count, "#{model_name.downcase} was", "#{model_name.downcase}s were")} successfully #{action}"
      end
    end

  end

  module BulkExport
    extend ActiveSupport::Concern

    def bulk_export
      tmp_files = []
      ids = params[:ids]
      return if ids.blank?
      filename = "group_#{ids[0]}.zip"

      group_file = Tempfile.new(File.basename(filename))
      zf = ZipFile.new(group_file.path)

      ids.each do |id|
        object = model.find(id)

        unless can? :read, object
          group_file.close
          FileUtils.rm(tmp_files)
          redirect_to index_path, alert: "#{model_name} #{object.name} could not be read"
        end

        archive = object.archive

        tmp_files << File.join(File.dirname(archive), "#{model_name.downcase}_#{object.id}.zip")
        FileUtils.cp(archive, tmp_files.last)
        zf.add_file(tmp_files.last)
      end

      zf.write
      group_file.close
      FileUtils.rm(tmp_files)

      send_file group_file.path, :type => 'application/zip', :filename => filename
    end
  end

  module BulkDelete
    extend ActiveSupport::Concern

    def bulk_delete
      errors = []
      success_count = 0

      params[:ids].each do |id|
        object = model.find(id)
        error = handle_authorize :destroy, object

        if error
          errors << error
        else
          delete_error = handle_object_delete object
          if delete_error then errors << delete_error else success_count += 1 end
        end
      end

      redirect_to index_path, notice: notice_helper(success_count, 'deleted'), alert: errors
    end
  end

  module BulkTag
    extend ActiveSupport::Concern

    def bulk_tag
      params[:tags] = params[:tags].join ','
      errors = []
      success_count = 0

      params[:ids].each do |id|
        object = model.find(id)

        error = handle_authorize :update, object

        if error
          errors << error
        else
          object.add_tags params[:tags]
          success_count += 1 if object.save
        end
      end

      redirect_to index_path,notice: notice_helper(success_count, 'tagged'), alert: errors
    end
  end
end