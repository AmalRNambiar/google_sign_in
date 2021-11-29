require 'google_sign_in/redirect_protector'

class GoogleSignIn::CallbacksController < GoogleSignIn::BaseController
  skip_forgery_protection only: :create

  def show
    redirect_to proceed_to_url, flash: { google_sign_in: google_sign_in_response }
  rescue GoogleSignIn::RedirectProtector::Violation => error
    logger.error error.message
    head :bad_request
  end

  def create
    redirect_to proceed_to_url, flash: { google_sign_in: google_one_tap_response }
  rescue GoogleSignIn::RedirectProtector::Violation => error
    logger.error error.message
    head :bad_request
  end

  private
    def proceed_to_url
      flash[:proceed_to].tap { |url| GoogleSignIn::RedirectProtector.ensure_same_origin(url, request) }
    end

    def google_sign_in_response
      if valid_request? && params[:code].present?
        { id_token: id_token }
      else
        { error: error_message_for(params[:error]) }
      end
    rescue OAuth2::Error => error
      { error: error_message_for(error.code) }
    end

    def google_one_tap_response
      if valid_request? && params[:credential].present?
        { id_token: params[:credential] }
      else
        { error: error_message_for(params[:error]) }
      end
    end

    def valid_request?
      if request.get?
        flash[:state].present? && params[:state] == flash[:state]
      else
        request.cookies['g_csrf_token'].present? ? params[:g_csrf_token] == request.cookies['g_csrf_token'] : true
      end
    end

    def id_token
      client.auth_code.get_token(params[:code])['id_token']
    end

    def error_message_for(error_code)
      error_code.presence_in(GoogleSignIn::OAUTH2_ERRORS) || "invalid_request"
    end
end
