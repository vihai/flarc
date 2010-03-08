module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module SchemaStatements
      
      # Adds a new index to the table.  +column_name+ can be a single Symbol, or
      # an Array of Symbols.
      #
      # The index will be named after the table and the first column name,
      # unless you pass +:name+ as an option.
      #
      # When creating an index on multiple columns, the first column is used as a name
      # for the index. For example, when you specify an index on two columns
      # [+:first+, +:last+], the DBMS creates an index for both columns as well as an
      # index for the first column +:first+. Using just the first name for this index
      # makes sense, because you will never have to create a singular index with this
      # name.
      #
      # ===== Examples
      # ====== Creating a simple index
      #  add_index(:suppliers, :name)
      # generates
      #  CREATE INDEX suppliers_name_index ON suppliers(name)
      # ====== Creating a unique index
      #  add_index(:accounts, [:branch_id, :party_id], :unique => true)
      # generates
      #  CREATE UNIQUE INDEX accounts_branch_id_party_id_index ON accounts(branch_id, party_id)
      # ====== Creating a named index
      #  add_index(:accounts, [:branch_id, :party_id], :unique => true, :name => 'by_branch_party')
      # generates
      #  CREATE UNIQUE INDEX by_branch_party ON accounts(branch_id, party_id)
      # ====== Creating a partial index
      # add_index(:accounts, [:branch_id, :party_id], :where => 'deleted_at IS NULL'
      # generates
      # CREATE UNIQUE INDEX accounts_branch_id_party_id_index ON accounts(branch_id, party_id) WHERE deleted_at IS NULL
      #
      def add_index(table_name, column_name, options = {})
        column_names = Array(column_name)
        index_name   = index_name(table_name, :column => column_names)
        partial      = nil

        if Hash === options # legacy support, since this param was a string
          index_type = options[:unique] ? "UNIQUE" : ""
          index_name = options[:name] || index_name
          partial = options[:where] if supports_partial_indexes?
        else
          index_type = options
        end
        quoted_column_names = column_names.map { |e| quote_column_name(e) }.join(", ")
        
        partial_condition = " WHERE #{partial}" unless partial.nil?
        execute "CREATE #{index_type} INDEX #{quote_column_name(index_name)} ON #{quote_table_name(table_name)} (#{quoted_column_names}) #{partial_condition}"
      end
      
      def supports_partial_indexes?
        false
      end
      
    end
    
    class PostgreSQLAdapter
      
      def supports_partial_indexes?
        true
      end
      
    end
    
    class MysqlAdapter
      
      def supports_partial_indexes?
        true
      end    
    end
    
  end
end
