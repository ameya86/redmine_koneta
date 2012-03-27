require 'redmine'
require 'koneta/access_controller_patch'
require 'koneta/application_helper_patch'
require 'koneta/search_controller_patch'

Redmine::Plugin.register :redmine_koneta do
  name 'Redmine Koneta plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_koneta'
  author_url 'http://blog.livedoor.jp/ameya86/'

  settings :default => {
            'notice_close_button' => '1',
            'project_menu_add_search' => '1',
          }, :partial => 'koneta/settings'

  menu :project_menu, :search, {:controller => 'search', :action => 'index'}, :params => :project_id, :caption => :label_search, :if => Proc.new{|p| p.module_enabled?(:search)}
end
