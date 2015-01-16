module Clearance
  class Configuration
    attr_writer :allow_sign_up, :allow_password_reset_expiration, :routes

    attr_accessor \
      :cookie_domain,
      :cookie_expiration,
      :cookie_name,
      :cookie_path,
      :httponly,
      :mailer_sender,
      :password_strategy,
      :redirect_url,
      :secure_cookie,
      :sign_in_guards,
      :user_model

    def initialize
      @allow_sign_up = true
      @allow_password_reset_expiration = false
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

    def user_model
      @user_model ||= ::User
    end

    def allow_sign_up?
      @allow_sign_up
    end

    def allow_password_reset_expiration?
      @allow_password_reset_expiration
    end

    def  user_actions
      if allow_sign_up?
        [:create]
      else
        []
      end
    end

    def user_id_parameter
      "#{user_model.model_name.singular}_id".to_sym
    end

    def routes_enabled?
      @routes
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
