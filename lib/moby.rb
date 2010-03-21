require 'rubygems'
require 'httparty'
require 'json'

class Moby
  def self.fetch
    result = HTTParty.get(
      'http://api.mobypicture.com/',
      :query => {
        :action => 'searchPosts',
        :k => '2bejXK0oEnftvaYu',
        :format => 'json',
        :searchUsername => 'jkreeftmeijer',
        :searchItemsPerPage => 1
      }
    )

    url = JSON.parse(result)['results'].first['post']['media']['url_full']
    %x(mkdir -p _site/images && curl -o _site/images/background.jpg #{url}) 
  end  
end
