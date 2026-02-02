require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyInstituteApi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true

    # 🔑 REQUIRED FOR DEVISE
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
                          key: "_my_institute_api_session"
  end
end
