require_dependency 'application_helper'

module KonetaApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods) # obj.method

    base.class_eval do
      alias_method_chain :render_flash_messages, :koneta
    end

  end

  module InstanceMethods # obj.method
    # 閉じるボタンを追加する
    def render_flash_messages_with_koneta
      if '1' == Setting.plugin_redmine_koneta['notice_close_button']
        s = ''
        flash.each do |k, v|
          s << "<div id=\"flash_#{k}\" class=\"flash #{k}\">\n"
          s << "<div style=\"float: right;\">"
          s << link_to_function('', "$(\"flash_#{k}\").hide();", :class => 'close-icon')
          s << "\n</div>\n#{v}\n</div>\n"
        end
        return s.html_safe
      else
        return render_flash_messages_without_koneta
      end
    end
  end
end

ApplicationHelper.send(:include, KonetaApplicationHelperPatch)
