require "hoe"

Hoe.plugins.delete :rubyforge
Hoe.plugin :doofus, :git, :isolate

Hoe.spec "audiosocket" do
  developer "Audiosocket", "it@audiosocket.com"

  self.extra_rdoc_files = Dir["*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.testlib          = :minitest
end
