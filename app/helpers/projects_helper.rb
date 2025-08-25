module ProjectsHelper
  def rubygem_org_url(gem_name)
    gem_name = gem_name.name if gem_name.kind_of? Rubygem

    "https://rubygems.org/gems/#{gem_name}"
  end
end
