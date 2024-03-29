# frozen_string_literal: true

class Api::ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :record_access

  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: -> { render_unauthorized(@scope); }

  private

  def record_access
    Journal.create(req: request.fullpath,
                   notes: request.method,
                   params: '',
                   token: request.headers['Authorization'] ||
                          request.headers['AUTHORIZATION'] ||
                          request.headers['HTTP_Authorization'] ||
                          request.headers['HTTP_AUTHORIZATION'])

  end

  def api_authenticate!(scope)
    @scope = scope

    Rails.logger.info '>>> api_authenticate!'

    if false && request.format != 'application/json'
      Rails.logger.error 'not json'
      Rails.logger.error request.format
      return false
    end

    header_token = ''

    authenticate_with_http_token do |token, options|
      header_token = token
      @token = Token.find(token)
    end
      
    if @token.nil? then
      Rails.logger.error "unauthorized, token #{header_token}"
      Rails.logger.error "unauthorized, token #{request.headers['AUTHORIZATION']}"
      Rails.logger.error "unauthorized, token #{request.headers['Authorization']}"
      Rails.logger.error "unauthorized, token #{request.headers['HTTP_Authorization']}"
      Rails.logger.error "unauthorized, token #{request.headers['HTTP_AUTHORIZATION']}"
      Rails.logger.error "headers\n#{request.headers.inspect}"

      return render_unauthorized(scope)
    end

    if @token.expires && @token.expires <= Time.now then
      Rails.logger.error "expired, token #{header_token}"
      Rails.logger.error "headers\n#{request.headers.inspect}"

      return render_expired(scope)
    end

    if @token.scope != scope then
      Rails.logger.error "out of scope, needed #{scope}, got #{@token.scope}"
      Rails.logger.error "headers\n#{request.headers.inspect}"

      return render_bad_scope(scope)
    end

    Rails.logger.info "GOOD TOKEN"
    @token
  end

  def render_unauthorized(scope)
    self.headers['WWW-Authenticate'] = "Token realm=#{scope}"
    render json: 'invalid token', status: 401
  end

  def render_bad_scope(scope)
    self.headers['WWW-Authenticate'] = "Token realm=#{scope}"
    render json: 'wrong scope', status: 401
  end

  def render_expired(scope)
    self.headers['WWW-Authenticate'] = "Token realm=#{scope}"
    render json: 'expired token', status: 401
  end

end
