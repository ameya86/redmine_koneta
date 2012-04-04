class KonetaController < ApplicationController
  before_filter :require_admin

  # 404 Not Foundを起こす
  def e404
    @project = Project.first if params[:p]
    raise ActiveRecord::RecordNotFound
  end

  # なんらかのエラーを起こす
  def e500
    @project = Project.first if params[:p]
    raise Exception
  end
end
