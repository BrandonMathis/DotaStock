desc "setup everything"
task :setup => [:update_vendor_assets, 'db:create', 'db:migrate'] do
end

desc "Update all vendored assets libs"
task :update_vendor_assets do
  rickshaw_js_path = Rails.root.join('vendor', 'assets', 'javascripts', 'rickshaw.js')
  rickshaw_css_path = Rails.root.join('vendor', 'assets', 'stylesheets', 'rickshaw.css')

  puts "================================================"
  puts "Retreiving Rickshaw.min.js from github on master"
  puts "================================================"
  %x[curl https://raw.github.com/shutterstock/rickshaw/master/rickshaw.min.js > #{rickshaw_js_path}]
  puts "================================================"
  puts "Retreiving Rickshaw.min.css from github on master"
  puts "================================================"
  %x[curl https://raw.github.com/shutterstock/rickshaw/master/rickshaw.min.css > #{rickshaw_css_path}]
end
