module RailsLightboxHelper
 def load_lightbox
   return javascript_include_tag("lightbox") + stylesheet_link_tag("lightbox")
 end

 #this function has not yet been tested use and debug at own risk
 #def link_to_url_lightbox(name, url_options ={}, html_options = {}, html_options_iframe = {})
 #  url = url_options.is_a?(String) ? url_options : self.url_for(url_options)
 #  link_to_function(name, "Lightbox.showBoxString(" + tag("iframe",html_options_iframe.merge(:src => url)) + ")", html_options)
 #end

 def link_to_lightbox_image(name, image_url)
   link_to_function(name, "Lightbox.showBoxString('" + image_tag(image_url) + "');")
 end

 def link_to_lightbox(name, id, html_options = {})
   link_to_function name, "Lightbox.showBoxByID('#{id.to_s}',null,null,false)", html_options
 end

 def link_to_component_lightbox(name, url_options = {}, html_options = {})
   id = id_from_url(url_options, html_options[:id])
   link_to_lightbox(name, id, html_options) + content_tag("span", render_component(url_options), :id => id, :style => 'display: none;')
 end

 def link_to_remote_lightbox(name, link_to_remote_options = {}, html_options = {}, lightbox_options = {})
   id = id_from_url(link_to_remote_options[:url], html_options[:id])
   hidden_content_id = lightbox_options[:hidden_content_id] || "hidden_content_#{id}"
   link_to_remote_options = lightbox_remote_options(link_to_remote_options, hidden_content_id, lightbox_options)

   if lightbox_options[:build_content].nil?
     return build_hidden_content(hidden_content_id, lightbox_options[:content_tag_type] || 'div') + link_to_remote(name, link_to_remote_options, html_options)
   else
     return link_to_remote(name, link_to_remote_options, html_options)
   end
 end

 def remote_lightbox(name, link_to_remote_options = {}, html_options = {}, lightbox_options = {})
   id = id_from_url(link_to_remote_options[:url], html_options[:id])
   hidden_content_id = "hidden_content_#{id}"
   link_to_remote_options = lightbox_remote_options(link_to_remote_options, hidden_content_id, lightbox_options)

   return remote_function(link_to_remote_options)
 end

 def build_lightbox_div(name, link_to_remote_options = {}, html_options = {}, lightbox_options = {})
   id = id_from_url(link_to_remote_options[:url], html_options[:id])
   hidden_content_id = "hidden_content_#{id}"
   return build_hidden_content(hidden_content_id)
 end

 def link_to_close_lightbox(name, html_options = {})
   link_to_function name, 'Lightbox.hideBox()', html_options
 end

 def button_to_close_lightbox(name, html_options = {})
   button_to_function name, 'Lightbox.hideBox()', html_options
 end

 def build_hidden_content(hidden_content_id, content_tag_type="div")
   content_tag(content_tag_type, '', :id => hidden_content_id, :style => 'display: none;overflow:hidden')
 end

private

 def id_from_url(url_options, link_id)
   result = ''
   result = link_id.to_s + '_' unless link_id.nil?

   if url_options.is_a? String
     result + url_options.delete(":/")
   else
     result + url_options.values.join('_').gsub(/[\W\s]/, '_')
   end
 end

 def lightbox_remote_options(remote_options, hidden_content_id, lightbox_options = {})
   remote_options[:update] = hidden_content_id
   #remote_options[:loading] = remote_options[:loading].to_s
   remote_options[:complete] = "Lightbox.showBoxByID('#{hidden_content_id}',#{lightbox_options[:width] || 'null'},#{lightbox_options[:height] || 'null'},true, #{lightbox_options[:show_box] || 'true'}); " + remote_options[:complete].to_s
   remote_options
 end


end