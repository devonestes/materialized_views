# frozen_string_literal: true
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

    private

    def execute_with_dependencies(view, schema)
      execute "REFRESH MATERIALIZED VIEW #{schema}.#{view}"
    end

    def execute(sql)
      puts sql
    end

    DEPENDENCY_SQL = <<-SQL.freeze
			SELECT r_ns.nspname || '.' || cl_r.relname AS materialized_view,
			array_agg(d_ns.nspname || '.' || cl_d.relname) AS depends_on
			FROM pg_rewrite AS r
			JOIN pg_class AS cl_r ON r.ev_class=cl_r.oid
			JOIN pg_depend AS d ON r.oid=d.objid
			JOIN pg_class AS cl_d ON d.refobjid=cl_d.oid
			JOIN pg_namespace AS r_ns ON r_ns.oid = cl_r.relnamespace
			JOIN pg_namespace AS d_ns ON d_ns.oid = cl_d.relnamespace
			WHERE cl_d.relkind = 'm'
			AND cl_r.relkind = 'm'
			AND cl_d.relname != cl_r.relname
			GROUP BY cl_r.relname, r_ns.nspname
			ORDER BY cl_r.relname;
    SQL
  end
end
