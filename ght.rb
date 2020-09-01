require 'optparse'
require_relative 'github'
require_relative 'gem_audit'

VERSION = "0.1.0"

Options = Struct.new(
  :org,
  :scan,
  :list,
  :lang,
  :rate
)
args = Options.new

OptionParser.new do |opts|
  opts.banner = "Usage: ght vulns"
  opts.program_name = "ght - Github Tools"
  opts.version = VERSION

  opts.on("--version", "Prints the version") do
    puts VERSION
    exit
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-oORG", "--organization=ORG", "Organization to query") do |org|
    args.org = org
  end

  opts.on("-L",  "List repositories") do
    args.list = true
  end

  opts.on("-l", "Show language") do
    args.lang = true
  end

  opts.on("-R", "Show rate limit") do
    args.rate = true
  end


  opts.on("-s", "Show vulnerability scan") do
    args.scan = true
  end
end.parse!

client = Github.client
if args.rate
  puts "Limit remaining #{client.rate_limit.remaining}"
  exit
end

unless args.org
  puts "You have to specify an organization for this action"
  exit
end

if args.list

  if args.scan
    gem_audit = GemAudit.new
  end

  Github.each_repo(client, args.org) do |repo, client|
    out = "#{repo.name}"

    if args.lang
      out += "\t#{repo.language || '?'}"
    end

    if args.scan
      out += "\t"
      if repo.language == "Ruby"
        begin
          file = Base64.decode64(Github.content(client, repo, "Gemfile.lock").content)
          results =  gem_audit.scan(file).map do |result|
            result[:name]
          end
          out += "#{results.count}\t#{results.join(',')}"
        rescue => e
          out += "?\t?"
        end
      else
        out += "?\t?"
      end
    end
    puts out
  end
end
