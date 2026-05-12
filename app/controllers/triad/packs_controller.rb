class Triad::PacksController < ApplicationController
  def index
    @packs = Pack.all.include_related
    @collection_ids = @character&.card_ids || []
    @keyed_collection_ids = @collection_ids.map { |id| "card-#{id}"}
    @comparison_ids = @comparison&.card_ids || []
  end
end
