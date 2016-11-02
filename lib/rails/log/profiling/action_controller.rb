require 'action_controller'

module ActionController
  class Base
    include Rails::Log::Profiling
    after_action :rails_query_profiling_logger_execute

    private
      def rails_query_profiling_logger_execute
        unless Rails::Log::Profiling.sqls.empty?
          controller_name = params[:controller].split("_").map(&:capitalize).join
          Rails::Log::Profiling.query_logger.info("\033[36m #{controller_name}Controller##{params[:action]}")
          Rails::Log::Profiling.query_logger.info("\n \033[36m" + Rails::Log::Profiling.sqls.count.to_s + "件のクエリの検知")
          Rails::Log::Profiling::QueryProfiling.execute
        end
      end
  end
end
