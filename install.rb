require 'fileutils'
require 'rubygems'

dir = File.dirname(__FILE__)
templates = File.join(dir, 'templates')
css = File.join('public', 'stylesheets', 'lightbox.css')
script = File.join('public', 'javascripts', 'lightbox.js')
images = File.join('public', 'images')

[css, script].each do |path| 
  FileUtils.cp(File.join(templates, path), File.join(RAILS_ROOT, path)) unless File.exist?(File.join(RAILS_ROOT, path))
end
["lightbox_blank.gif", "lightbox_close.gif", "lightbox_overlay.png"].each do |image|
  FileUtils.cp(File.join(templates, images, image), File.join(RAILS_ROOT, images))
end
#puts IO.read(File.join(dir, 'README.rdoc'))
