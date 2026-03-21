class SearchController < ApplicationController
  include PrivateCollection
  include Typeable
  before_action -> { check_privacy!(:mounts, :minions, :facewear) }
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    @types = collectable_types

    @owned = @types.each_with_object({}) do |type, h|
      key = type[:value].downcase.pluralize

      h[type[:model]] = {
        count: Redis.current.hgetall("#{key}-count"),
        percentage: Redis.current.hgetall(key)
      }
    end

    @hidden_types = cookies[:hidden_types_search]&.split(',')&.map(&:constantize) || []
    @models = @types.pluck(:model)
    @source_types = SourceType.all.with_filters(cookies).ordered
    @patches = searchable_patches
    @search = ransack_with_patch_search

    @collectables = @models.flat_map do |model|
      # The search form needs a query, so we will eventually set it to the last search
      @q = model.include_sources.with_filters(cookies, @character).ransack(@search)

      collectables = @q.result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables
    end

    if @character.present?
      @owned_ids = @models.each_with_object({}) do |model, h|
        h[model.to_s.underscore.pluralize.to_sym] = @character.send("#{model.to_s.underscore}_ids")
      end
    end
  end
end
