class Mod::SourcesController < ModController
  def destroy
    if Source.find(params[:id]).destroy
      flash[:success] = t('mod.source_destroy_success')
    else
      flash[:error] = t('mod.source_destroy_error')
    end

    redirect_back(fallback_location: root_path)
  end
end
