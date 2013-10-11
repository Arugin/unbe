if defined?(Rails.configuration) && Rails.configuration.respond_to?(:middleware)
  require 'google_ajax_crawler'
  Rails.configuration.middleware.insert_before ActionDispatch::Static, GoogleAjaxCrawler::Crawler do |config|
    config.page_loaded_test = -> driver { driver.page.evaluate_script('document.getElementById("loading") == null') }
  end
end