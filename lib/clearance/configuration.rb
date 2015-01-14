module Clearance
  class Configuration
    # @attribute [w] allow_sign_up
    #   @param value [Boolean]
    #   Set to false to disable Clearance's user creation routes.
    #   Ignored if routes are disabled.
    attr_writer :allow_sign_up

    # @attribute [w] routes
    # Set to false to disable all Clearance routes.
    # When set to false, your app is responsible for all routes. You can dump
    # a copy of Clearance's default routes with `rails generate
    # clearance:routes`.
    # @param value [Boolean]
    attr_writer :routes

    # The domain to use for the clearance remember token cookie.
    # @param [String]
    # @return [String]
    attr_accessor :cookie_domain

    # A lambda called to set the remember token cookie expiration.
    # The lambda accepts the collection of cookies as an argument which
    # allows for changing the expiration according to those cookies.
    # This could be used, for example, to set a session cookie unless
    # a `remember_me` cookie was also present. By default, cookie expiration
    # is one year.
    # @param value [Lambda]
    # @return [Lambda]
    attr_accessor :cookie_expiration

    # Should the HttpOnly flag be set on the remember token cookie?
    # If true, the cookie will not be made available to JavaScript.
    # Defaults to false.
    # @param value [Boolean]
    # @return [Boolean]
    attr_accessor :httponly

    attr_accessor \
      :cookie_name,
      :cookie_path,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :secure_cookie,
      :sign_in_guards,
      :user_model

    def initialize
      @allow_sign_up = true
      @cookie_expiration = ->(cookies) { 1.year.from_now.utc }
      @cookie_path = '/'
      @cookie_name = "remember_token"
      @httponly = false
      @mailer_sender = 'reply@example.com'
      @redirect_url = '/'
      @routes = true
      @secure_cookie = false
      @sign_in_guards = []
    end

    # @return [Class] the configured user model.
    def user_model
      @user_model ||= ::User
    end

    # @return [Boolean] Is user sign up enabled?
    def allow_sign_up?
      @allow_sign_up
    end

    # @return Array<Symbol> the actions enabled for the user resource
    #   when using Clearance's internal routes.
    def  user_actions
      if allow_sign_up?
        [:create]
      else
        []
      end
    end

    # @return [Symbol]
    def user_id_parameter
      "#{user_model.model_name.singular}_id".to_sym
    end

    # @return [Boolean] are Clearance's internal routes enabled?
    def routes_enabled?
      @routes
    end
  end

  # @return [Clearance::Configuration] Clearance's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Clearance's configuration
  # @param config [Clearance::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Clearance's current configuration
  #   Clearance.configure do |config|
  #     config.routes = false
  #   end
  # @yieldparam [Clearance::Configuration] the current configuration
  def self.configure
    yield configuration
  end
end
