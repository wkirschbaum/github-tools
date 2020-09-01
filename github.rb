require 'octokit'

class Github
  def self.client
    Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def self.rate_limit(client)
    client.rate_limit.remaining
  end

  def self.each_repo(client, org)
    client.auto_paginate = true

    client.org_repos(org).each do |repo|
      next if repo.archived?

      yield repo, client
    end
  end

  def self.content(client, repo, path)
    client.contents(repo.full_name, path: path)
  end
end
