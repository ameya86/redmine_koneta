require_dependency 'redmine/access_control'

module KonetaAccessControlPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods) # self.method

    class << Redmine::AccessControl
      alias_method_chain :available_project_modules, :koneta
    end

  end

  module ClassMethods # self.method
    # モジュールに「検索」を追加
    def available_project_modules_with_koneta
      if '1' == Setting.plugin_redmine_koneta['project_menu_add_search']
        available_project_modules_without_koneta + [:search]
      else
        available_project_modules_without_koneta
      end
    end
  end
end

Redmine::AccessControl.send(:include, KonetaAccessControlPatch)
