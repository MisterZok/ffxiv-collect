class TitlesController < ApplicationController
  include PrivateCollection

  before_action -> { check_privacy!(:achievements) }
  skip_before_action :set_owned!, :set_ids!, :set_prices!

  def index
    @q = Title.ransack(params[:q])
    @titles = @q.result.include_related.ordered.distinct

    if cookies[:limited] == 'hide'
      @titles = @titles.joins(:achievement).merge(Achievement.exclude_time_limited)
    end

    if cookies[:ranked_pvp] == 'hide'
      @titles = @titles.joins(:achievement).merge(Achievement.exclude_ranked_pvp)
    end

    @collection_ids = @character&.achievement_ids || []
    @keyed_collection_ids = @collection_ids.map { |id| "achievement-#{id}"}
    @owned = {
      count: Redis.current.hgetall('achievements-count'),
      percentage: Redis.current.hgetall('achievements')
    }
  end
end
