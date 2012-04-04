require_dependency 'application_controller'

class ApplicationController < ActionController::Base
  # Webrickなど
  def rescue_action_locally(exception)
    if '1' == Setting.plugin_redmine_koneta['catch_error']
      begin
        rescue_action_in_public(exception)
      rescue => ex
        super(exception)
      end
    else
      super(exception)
    end
  end

  # Passengerなど
  def rescue_action_in_public(exception)
    if '1' == Setting.plugin_redmine_koneta['catch_error']
      begin
        rescue_has_layout(exception)
      rescue => ex
        super(exception)
      end
    else
      super(exception)
    end
  end

  # デフォルトのエラーページではなく、
  # Redmineのデザインでエラーを表示する
  def rescue_has_layout(exception)
    response = response_code_for_rescue(exception)
    case response_code_for_rescue(exception)
    when :not_found # 404
      render_404
    else
      render_error l(:error_occurred)
    end
  end
end
