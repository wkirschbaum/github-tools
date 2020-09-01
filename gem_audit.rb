require 'bundler/audit/scanner'
require 'bundler/audit/database'

module Bundler
  module Audit
    class Scanner
      def initialize(lockfile)
        @database = Database.new
        @lockfile = LockfileParser.new(lockfile)
      end
    end
  end
end

class GemAudit
  def initialize
    Bundler::Audit::Database.update!(quiet: true)
  end

  def exclude_list
    [
      "omniauth"
    ]
  end

  def scan(file)
    Bundler::Audit::Scanner.new(file).scan.map do |result|
      {
        name: result.gem.name,
        current_version: result.gem.version.to_s,
        auditor: "bundler-audit",
        advisory: {
          id: result.advisory.id,
          url: result.advisory.url,
          date: result.advisory.date,
          description: result.advisory.description
        }
      }
    end
      .uniq { |p| p[:name] }
      .reject { |p| exclude_list.include?(p[:name]) }
  end
end
