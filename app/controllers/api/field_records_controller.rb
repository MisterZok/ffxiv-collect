class Api::FieldRecordsController < ApiController
  def index
    query = FieldRecord.all.ransack(@query)
    @field_records = query.result.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @field_record = FieldRecord.include_sources.find_by(id: params[:id])
    render_not_found unless @field_record.present?
  end
end
