require 'bundler'
include Rake::DSL
Bundler::GemHelper.install_tasks

task :default => ['spec', 'test:conformance']
task :test => :spec

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

def conformance_version(dir)
  require 'digest'
  Dir[File.join(dir, '*')].inject(Digest::SHA1.new){|digest, file| digest.update(Digest::SHA1.file(file).hexdigest) }
end

namespace :test do
  namespace :conformance do
    desc "Update conformance testing data"
    task :update do
      puts "Updating conformance data ... "
      system("git submodule init") || raise("Failed to init submodule")
      system("git submodule update") || raise("Failed to update submodule")
      puts "Updating conformance data ... DONE"
    end

    desc "Change conformance test data to the lastest version"
    task :latest => ['conformance:update'] do
      current_dir = File.dirname(__FILE__)
      submodule_dir = File.join(File.dirname(__FILE__), "test", "twitter-text-conformance")
      version_before = conformance_version(submodule_dir)
      system("cd #{submodule_dir} && git pull origin master") || raise("Failed to pull submodule version")
      system("cd #{current_dir}")
      if conformance_version(submodule_dir) != version_before
        system("cd #{current_dir} && git add #{submodule_dir}") || raise("Failed to add upgrade files")
        system("git commit -m \"Upgraded to the latest conformance suite\" #{submodule_dir}") || raise("Failed to commit upgraded conformacne data")
        puts "Upgraded conformance suite."
      else
        puts "No conformance suite changes."
      end
    end

    desc "Run conformance test suite"
    task :run do
      ruby '-rubygems', "test/conformance_test.rb"
    end
  end

  desc "Run conformance test suite"
  task :conformance => ['conformance:update', 'conformance:run'] do
  end
end

require 'rdoc/task'
namespace :doc do
  RDoc::Task.new do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_dir = 'doc'
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  end
end

desc "Run cruise control build"
task :cruise => [:spec, 'test:conformance'] do
end

namespace :tld do
  task :update do
    require 'open-uri'
    require 'nokogiri'

    file = File.join(File.dirname(__FILE__), 'lib', 'twitter-text', 'regex.rb')

    # Get a list of TLDs.
    tlds = []
    document = Nokogiri::HTML(open('http://www.iana.org/domains/root/db'))
    document.css('table#tld-table tr').each do |tr|
      info = tr.css('td')
      tlds << { :domain => info[0].text.gsub('.', ''), :type => info[1].text } unless info.empty?
    end

    # Update ccTLD regex.
    cctlds = tlds.select { |tld| tld[:type] =~ /country-code/ }.map { |tld| tld[:domain] }.sort
    replacement = "      (?:\n        (?:\n          "
    replacement << cctlds.join('|').scan(/.{1,109}(?:\||\z)/).join("\n          ")
    replacement << "\n        )\n      (?=[^0-9a-z@]|$))"

    text = File.read(file)
    text.gsub!(/(REGEXEN\[:valid_ccTLD\] = %r\{\n)(.*?)(\s+\}ix)/m, "\\1#{replacement}\\3")
    File.open(file, 'w') { |f| f.puts text }

    # Update gTLD regex.
    gtlds = tlds.select { |tld| tld[:type] =~ /generic|sponsored|infrastructure|generic-restricted/ }.map { |tld| tld[:domain] }.sort
    replacement = "      (?:\n        (?:\n          "
    replacement << gtlds.join('|').scan(/.{1,109}(?:\||\z)/).join("\n          ")
    replacement << "\n        )\n      (?=[^0-9a-z@]|$))"

    text = File.read(file)
    text.gsub!(/(REGEXEN\[:valid_gTLD\] = %r\{\n)(.*?)(\s+\}ix)/m, "\\1#{replacement}\\3")
    File.open(file, 'w') { |f| f.puts text }

    # Commit changes.
    system("cd #{File.dirname(__FILE__)} && git add #{file} && git commit -m \"Update gTLD and ccTLD lists.\"")
  end
end
