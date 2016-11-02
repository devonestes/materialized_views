# This is the module that has our single public API method
module MaterializedView
  class << self
    def refresh(view, schema: :public, with_dependencies: false)
      if with_dependencies
        execute_with_dependencies(view, schema)
      else
        execute "REFRESH MATERIALIZED VIEW #{schema}.#{view}"
      end
    end

    def execute_with_dependencies(view, schema)
      execute "REFRESH MATERIALIZED VIEW #{schema}.#{view}"
    end

    def execute(sql)
      puts 'EXECUTING'
      puts sql
    end
  end
end
