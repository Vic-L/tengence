class BrainTreeController < ApplicationController
  before_action :authenticate_user!, only: [:upgrade, :checkout]

  def upgrade
  end
end
