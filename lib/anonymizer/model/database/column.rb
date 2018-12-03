# frozen_string_literal: true

# Basic class to communication with databese
class Database
  # Class to anonymize EAV data type
  class Column < Database
    def self.query(table_name, column_name, info)
      column_type = info['type']

      querys = []

      query = "UPDATE #{table_name} SET #{column_name} = ("
      query += manage_type(column_type)
      query += "WHERE #{table_name}.#{column_name} IS NOT NULL"
      query += fill_where_clause(info, table_name)

      querys.push query

      querys
    end

    def self.manage_type(type)
      query = ''

      if type == 'id'
        query += 'SELECT FLOOR((NOW() + RAND()) * (RAND() * 119))) '
      else
        query += prepare_select_for_query(type)
        query += 'FROM fake_user ORDER BY RAND() LIMIT 1) '
      end

      query
    end

    def self.fill_where_clause(info, table_name)
      query = ''

      if info.key?('where')
        info['where'].each do |where_info|
          query += " #{where_info['logical_operator']} "
          query += "#{table_name}.#{where_info['column']} #{where_info['operator']} '#{where_info['value']}'"
        end
      end

      query
    end
  end
end
