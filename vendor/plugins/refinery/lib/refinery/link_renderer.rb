class Refinery::LinkRenderer < WillPaginate::LinkRenderer
	
	def url_for(page)
		page_one = page == 1
    unless @url_string and !page_one
      @url_params = {}
      # page links should preserve GET parameters
      stringified_merge @url_params, @template.params if @template.request.get?
      stringified_merge @url_params, @options[:params] if @options[:params]
      
      if complex = param_name.index(/[^\w-]/)
        page_param = parse_query_parameters("#{param_name}=#{page}")
        
        stringified_merge @url_params, page_param
      else
        @url_params[param_name] = page_one ? 1 : 2
      end

			url = @template.url_for((@options[:url]||{}).merge!(@url_params))
      return url if page_one
      
      if complex
        @url_string = url.sub(%r!((?:\?|&amp;)#{CGI.escape param_name}=)#{page}!, '\1@')
        return url
      else
        @url_string = url
        @url_params[param_name] = 3
        @template.url_for(@url_params).split(//).each_with_index do |char, i|
          if char == '3' and url[i, 1] == '2'
            @url_string[i] = '@'
            break
          end
        end
      end
    end
    # finally!
    @url_string.sub '@', page.to_s
	end
	
end