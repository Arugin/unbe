module Concerns
  module Votable
    extend ActiveSupport::Concern

    def vote_up
      session[:votable] ||= request.referer
      item = instance_variable_set(:"@#{controller_name.singularize}", resource.find(params[:id]))
      current_user.vote(item, :up)
      redirect_to session.delete(:votable)
    end

    def vote_down
      session[:votable] ||= request.referer
      item = instance_variable_set(:"@#{controller_name.singularize}", resource.find(params[:id]))
      current_user.vote(item, :down)
      redirect_to session.delete(:votable)
    end

    def resource
      (defined? _resource) ? _resource : controller_name.singularize.camelize.constantize
    end

    module ClassMethods
      def resource_name(name)
        define_method(:_resource) do
          name
        end
      end
    end

  end
end