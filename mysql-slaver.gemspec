# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mysql-slaver"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.authors          = ["David Salgado"]
  s.date             = "2014-04-16"
  s.email            = "david@digitalronin.com"
  s.executables      = ["mysql_slaver"]
  s.extra_rdoc_files = ["README.md"]
  s.files            = [
    "Gemfile",
    "Gemfile.lock",
    "Rakefile",
    "README.md",
    "bin/mysql_slaver",
    "spec/mysql_slaver",
    "spec/mysql_slaver/db_copier_spec.rb",
    "spec/mysql_slaver/executor_spec.rb",
    "spec/mysql_slaver/master_changer_spec.rb",
    "spec/mysql_slaver/slaver_spec.rb",
    "spec/mysql_slaver/status_fetcher_spec.rb",
    "spec/spec_helper.rb",
    "lib/mysql_slaver",
    "lib/mysql_slaver/db_copier.rb",
    "lib/mysql_slaver/executor.rb",
    "lib/mysql_slaver/logger.rb",
    "lib/mysql_slaver/master_changer.rb",
    "lib/mysql_slaver/mysql_command.rb",
    "lib/mysql_slaver/slaver.rb",
    "lib/mysql_slaver/status_fetcher.rb",
    "lib/mysql_slaver.rb"
  ]
  s.homepage         = "https://github.com/digitalronin/mysql-slaver"
  s.rdoc_options     = ["--main", "README.md"]
  s.require_paths    = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary          = "Setup mysql replication on a slave (localhost), from a remote master, over SSH"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
