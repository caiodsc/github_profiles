# frozen_string_literal: true

class ShortLinksController < ApplicationController
  before_action :set_user, only: :show

  def show
    redirect_to @user.github_url, allow_other_host: true
  end

  private

  def set_user
    @user = User.find_by!(unique_identifier:)
  end

  def unique_identifier
    ShortCode.decode(params[:id])
  end
end
