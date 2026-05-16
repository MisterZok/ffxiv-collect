class MountsController < ApplicationController
  include PrivateCollection
  before_action -> { check_privacy!(:mounts) }

  def index
    @q = Mount.ransack(params[:q])
    @mounts = @q.result.include_related.with_filters(cookies).ordered.distinct
    @types = source_types(:mount)
  end

  def show
    @mount = Mount.include_sources.find(params[:id])
  end
end
