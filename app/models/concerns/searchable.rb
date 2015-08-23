module Concerns
  module Searchable
    extend ActiveSupport::Concern

    module ClassMethods
      def search_for(params = {}, base_scope)
        base_scope ||= all

        if params[:search].present?
          scope = with_search(params, base_scope)
        else
          scope = without_search(params, base_scope)
        end
        scope
      end

      protected

      def with_search(params, scope)
        scope = scope.search(params[:search])
        if params[:sort_by].present? || params[:direction].present?
          init_params params
          scope = scope.reorder(params[:sort_by].to_sym => params[:direction].to_sym)
        end
        scope
      end

      def init_params(params)
        params[:sort_by] ||= 'created_at'
        params[:direction] ||= 'desc'
      end

      def without_search(params, scope)
        init_params params
        scope.order(params[:sort_by].to_sym => params[:direction].to_sym)
      end

    end

  end
end