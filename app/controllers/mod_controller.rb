class ModController < ApplicationController
  include Typeable

  before_action :authenticate_mod!
  before_action :set_paper_trail_whodunnit

  def index
    @models = collectable_types(dashboard: true).pluck(:model)
    @changes = PaperTrail::Version.includes(:user).order(id: :desc).paginate(page: params[:page])
  end

  private
  def authenticate_mod!
    redirect_to not_found_path unless current_user&.mod?
  end
end
