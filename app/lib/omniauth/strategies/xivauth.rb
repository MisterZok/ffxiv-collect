require 'omniauth-oauth2'

# Provide the strategy locally until the gem is ready
module OmniAuth
  module Strategies
    class XIVAuth < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "user".freeze

      option :name, "xivauth"

      option :client_options, {
        site: "https://xivauth.net/api/v1/",
        authorize_url: "/oauth/authorize",
        token_url: "/oauth/token"
      }

      option :authorize_options, [ :scope ]

      info do
        {
          name: user_data['display_name'],
          email: user_data['email_verified'] ? user_data['email'] : nil,
        }
      end

      uid { user_data['id'] }

      extra do
        {
          characters: character_data
        }
      end

      def user_data
        @user_data ||= access_token.get('user').parsed
      end

      def character_data
        @character_data ||= access_token.get('characters').parsed
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |option|
            params[option] = request.params[option.to_s] if request.params[option.to_s]
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end
    end
  end
end
