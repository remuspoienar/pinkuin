class ResourceMetadataController < ApplicationController

  before_action :authenticate_user!

  def select_options
    resource_klass = metadata[:resource_type].constantize
    records        = resource_klass.for_select_options

    respond_to do |format|
      format.html { render partial: 'select_options', locals: { records: records } }
      format.json { render json: records.as_json, status: :ok }
    end
  rescue NameError, LoadError
    head :no_content
  end

  private

  def metadata
    params.permit(:resource_type, :format)
  end
end
