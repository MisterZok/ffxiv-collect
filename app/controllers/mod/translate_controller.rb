class Mod::TranslateController < ModController
  include Typeable

  def index
    @models = collectable_types(dashboard: true).pluck(:model)
    @source_types = SourceType.all.with_filters(cookies).ordered

    @collectables = @models.flat_map do |model|
      @q = model.include_related.ransack(params[:q])

      collectables = @q.result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables = collectables.includes(sources: [:type]) unless @skip_sources

      if model == SurveyRecord
        collectables = collectables.where("solution_#{I18n.locale}" => nil)
      else
        # If a collectable has multiple untranslated sources, only display it once
        collectables = collectables.joins(:sources).where("sources.text_#{I18n.locale}" => nil).distinct
      end

      collectables
    end

    @collectables = @collectables.paginate(page: params[:page])
  end
end
