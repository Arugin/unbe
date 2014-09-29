module ApplicationHelper
  def medium_form
    haml_tag :div, class: 'row' do
      haml_tag :div, class: 'col-md-6' do
        yield
      end
    end
  end
end