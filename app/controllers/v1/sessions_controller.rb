module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!

    # POST /v1/login
    def create
      @user = User.find_for_database_authentication(email: params[:username])
      return invalid_login_attempt unless @user

      if @user.valid_password?(params[:password])
        sign_in :user, @user
        render json: @user, serializer: SessionSerializer, root: nil
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end

    # can login like this:

#     curl localhost:3000/v1/login --data "username=some@email.com&password=password"
# {
#   "token_type": "Bearer",
#   "user_id": 1,
#   "access_token": "1:VNBFMX_ZyjVh9mqLPD9f"
# }

#     curl localhost:3000/v1/login --data "username=some@email.com&password=password"

#      {
#   "token_type": "Bearer",
#   "user_id": 1,
#   "access_token": "1:VNBFMX_ZyjVh9mqLPD9f"
# }

  end
end