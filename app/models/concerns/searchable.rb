module Concerns
  module Searchable

    def self.included(base)
      base.class_eval do |klass|

        #Include mongoid search to have support for full_text_search
        include Mongoid::Search

=begin
        Performs search for included class objects based on following:
         - if passed params contains search key and it's length more then mongoid minimum word size
              search is performed on all searchable fields for the value (using )
         - if passed params contains scope for current user and class has support for Concerns::Privatable then
              only objects for current user are returned
         - if class does not have support for Concerns::Privatable then all objects are returned
=end
        klass.scope :search_for, lambda { |user, params = {}|
          query_search = all
          unless params[:search].blank?
            if params[:search].length >= Mongoid::Search.minimum_word_size
              query_search = full_text_search(params[:search])
            end
          end

          if !params[:scope].blank? && params[:scope] == 'current_user'
            query_user = of(user)
          elsif respond_to?(:all_for)
            query_user = all_for(user)
          else
            query_user = all
          end
          all_of([query_search.selector, query_user.selector])
        }

      end

    end

  end

end