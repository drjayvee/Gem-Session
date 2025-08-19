#!/usr/bin/env ruby
# frozen_string_literal: true

#
# Lists gemmable gems to stdout in YAML format.
# Must be run from the root of a rubygems.org repo.
# You'll most likely have to copy (or symlink) this script first.
# Depends on a database dump loaded in the development environment.
#

ENV["RAILS_ENV"] ||= "development"
require_relative "../config/environment"
ActiveRecord::Base.logger.level = 1

# SELECT gem.id, gem.name
# FROM rubygems gem
#
# -- at least ten versions since 2020
# INNER JOIN (
#     SELECT rubygem_id
#     FROM versions
#     WHERE created_at >= '2020-01-01'
#     GROUP BY rubygem_id
#     HAVING COUNT(id) >= 10
# ) ver ON ver.rubygem_id = gem.id
#
# -- 10k to 1M downloads
# INNER JOIN gem_downloads down ON down.rubygem_id = gem.id
#     AND down.version_id = 0 AND down.count BETWEEN 10000 AND 1000000
#
# -- "home" link
# INNER JOIN linksets link ON link.rubygem_id = gem.id
#    AND link.home IS NOT NULL

gemmables = Rubygem
  .with_versions
  .order(:name)
  .lazy
  .filter { it.versions.where("created_at > '2020-01-01'").count >= 10 }
  .filter { it.downloads.between?(10_000, 1_000_000) }
  .filter { it.most_recent_version.description.present? && it.linkset&.home.present? }

# gemmables = gemmables.first(10) # useful for debugging

gemmables_hash = gemmables.each_with_object({}) do |rubygem, hash|
  hash[rubygem.name] = {
    description: rubygem.most_recent_version.description,
    homepage_url: rubygem.linkset.home
  }
end

puts gemmables_hash.to_yaml(stringify_names: true)
