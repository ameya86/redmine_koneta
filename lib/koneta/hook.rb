class KonetaHook < Redmine::Hook::ViewListener
  render_on :view_projects_form, :partial => 'koneta/tracker_custom_field'
end
