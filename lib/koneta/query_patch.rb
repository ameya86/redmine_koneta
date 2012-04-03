require_dependency 'query'

module KonetaQueryPatch
  def self.included(base) # :nodoc:

    class << Query
      alias_method_chain :operators_by_filter_type, :all_or_nothing
    end
  end
end

class Query < ActiveRecord::Base
  @@operators_by_filter_type_with_all_or_nothing = nil

  # テキスト、長いテキスト、日付系の条件に「なし」「すべて」を加える
  def self.operators_by_filter_type_with_all_or_nothing
    if '1' == Setting.plugin_redmine_koneta['all_or_nothing_filter']
      # 本来のものとは別の変数に作成し、そちらを返す
      if @@operators_by_filter_type_with_all_or_nothing.nil?
        # 1回目の呼び出しで作成する
        @@operators_by_filter_type_with_all_or_nothing = @@operators_by_filter_type.dup
        @@operators_by_filter_type_with_all_or_nothing[:date] |= ["*", "!*"]
        @@operators_by_filter_type_with_all_or_nothing[:text] |= ["*", "!*"]
        @@operators_by_filter_type_with_all_or_nothing[:string] |= ["*", "!*"]
      end

      return @@operators_by_filter_type_with_all_or_nothing
    else
      return @@operators_by_filter_type
    end
  end
end

Query.send(:include, KonetaQueryPatch)
