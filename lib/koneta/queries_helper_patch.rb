require_dependency 'queries_helper'

module KonetaQueriesHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods) # obj.method

    base.class_eval do
      alias_method_chain :column_content, :before_assignee
    end

  end

  module InstanceMethods # obj.method
    # チケット一覧に表示する際、担当者列の処理を変更する
    def column_content_with_before_assignee(column, issue)
      # 担当者でグループ化されている場合は
      # 表示が狂ってしまうので除外

      # 何度も判定するのは手間なのでグループ化判定は変数に記憶しておく
      if @add_before_assigned_to_column.nil?
        @add_before_assigned_to_column = !(@query && @query.grouped? && :assigned_to == @query.group_by_column.name) && '1' == Setting.plugin_redmine_koneta['show_old_assignee']
      end

      if :assigned_to == column.name && @add_before_assigned_to_column
        j = Journal.table_name
        d = JournalDetail.table_name
        detail = JournalDetail.find(:first, :select => "#{d}.id, #{d}.old_value",
                                    :joins => "join #{j} on #{j}.id = #{d}.journal_id",
                                    :conditions => ["#{j}.journalized_id = ? and #{j}.journalized_type = ? and #{d}.prop_key = ?", issue.id, 'Issue', 'assigned_to_id'], 
                                    :order => "#{j}.created_on desc")
        if detail
          # 変更前の担当者
          before = nil
          if detail.old_value
            user = User.find(:first, :select => 'id, firstname, lastname, status', :conditions => {:id => detail.old_value})
            before = link_to_user(user) if user
          end
          before ||= l(:label_none)

          # 現在の担当者
          after = (issue.assigned_to)? link_to_user(issue.assigned_to) : l(:label_none)

          return "#{before} &#8594; #{after}"
        end
      end
      # マッチがなければオリジナルを呼ぶ
      return column_content_without_before_assignee(column, issue)
    end
  end
end

QueriesHelper.send(:include, KonetaQueriesHelperPatch)
