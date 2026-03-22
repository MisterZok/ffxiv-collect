class Mod::TranslateController < ModController
  include Typeable

  def index
    @source_types = SourceType.ordered
    @q = Source.ransack(params[:q])
    @sources = @q.result
      .where("sources.text_#{I18n.locale}" => nil)
      .preload(:collectable)
      .order(id: :desc)
      .paginate(page: params[:page])
  end
end
