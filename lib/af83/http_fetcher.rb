module AF83
  class HTTPFetcher
    def self.get_resource(*args)
      new.get_resource(*args)
    end

    def get_resource(host:, path:, token: nil, params: {}, parse_json: false) 
      Faraday.new(url: host) do |c|
        c.headers['Authorization'] = "Token token=#{token.inspect}" if token
        c.adapter  Faraday.default_adapter

        resp = c.get path, params
        if resp.status == 200
          return parse_json ? JSON.parse(resp.body) : resp.body
        else
          raise "Error on api request status : #{resp.status} => #{resp.body}"
        end
      end
    end
  end
end
