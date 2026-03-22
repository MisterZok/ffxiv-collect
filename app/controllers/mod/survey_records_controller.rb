class Mod::SurveyRecordsController < Mod::CollectablesController
  before_action :skip_sources

  def index
    @sprite_key = 'survey_records-small'
    super
  end
end
