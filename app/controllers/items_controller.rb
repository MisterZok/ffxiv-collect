class ItemsController < ApplicationController
  def show
    item = Item.find_by(id: params[:id])
    collectable = item&.unlock

    return redirect_to not_found_path if collectable.nil?

    redirect_to polymorphic_path(collectable)
  end
end
