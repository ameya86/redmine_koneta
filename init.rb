require 'redmine'
require 'koneta'

Redmine::Plugin.register :redmine_koneta do
  name 'Redmine Koneta plugin'
  author 'OZAWA Yasuhiro'
  description 'This is a plugin for Redmine'
  version '0.0.7'
  url 'https://github.com/ameya86/redmine_koneta'
  author_url 'http://blog.livedoor.jp/ameya86/'

  settings :default => {
            'notice_close_button' => '1',
            'project_menu_add_search' => '1',
            'all_activities' => '1',
            'all_issues' => '1',
            'all_gantts' => '1',
            'all_calendars' => '1',
            'all_time_entries' => '1',
            'all_news' => '1',
            'all_search' => '1',
            'show_old_assignee' => '1',
            'project_setting_custom_fields_trackers' => '1',
            'all_or_nothing_filter' => '1',
            'catch_error' => '1',
          }, :partial => 'koneta/settings'

  # プロジェクトメニュー
  menu :project_menu, :search, {:controller => 'search', :action => 'index'}, :params => :project_id,
                      :caption => :label_search, :if => Proc.new{|p| p.module_enabled?(:search)}

  # アプリケーションメニュー
  menu :application_menu, :activity, {:controller => 'activity', :action => 'index'},
                          :caption => :label_activity, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_activities'] }
  menu :application_menu, :issues, {:controller => 'issues', :action => 'index'},
                          :caption => :label_issue_plural, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_issues'] }
  menu :application_menu, :gantt, {:controller => 'gantts', :action => 'show'},
                          :caption => :label_gantt, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_gantts'] }
  menu :application_menu, :calendar, {:controller => 'calendars', :action => 'show'},
                          :caption => :label_calendar, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_calendars'] }
  menu :application_menu, :time_entries, {:controller => 'time_entries', :action => 'index'},
                          :caption => :label_time_entry_plural, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_time_entries'] }
  menu :application_menu, :news, {:controller => 'news', :action => 'index'},
                          :caption => :label_news_plural, :if => Proc.new{|p| '1' == Setting.plugin_redmine_koneta['all_news'] }
  menu :application_menu, :search, {:controller => 'search', :action => 'index'},
                          :caption => :label_search, :if => Proc.new{|p| ;'1' == Setting.plugin_redmine_koneta['all_search'] }
end
