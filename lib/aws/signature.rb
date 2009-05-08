require 'hmac-sha2'
require 'base64'
require 'uri'

module Aws
  module Signature
    
    def self.generate(url, params, aws_secret_access_key, method="GET")
      uri = URI.parse(url)
      query_string = params.sort.map{|k,v| "#{escape(k)}=#{escape(v)}" } * "&"
      to_sign = "#{method}\n#{uri.host}\n#{uri.path}\n#{query_string}"
      hmac = HMAC::SHA256.new(aws_secret_access_key)
      Base64.encode64(hmac.update(to_sign.strip).digest).strip
    end
    
    def self.signed_query_params(url, params, method="GET")
      params.merge!({
        'SignatureMethod' => 'HmacSHA256',
        'SignatureVersion' => '2',
        'Timestamp' => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        'Version' => '2009-03-01'
      })
      signature = generate(url, params, method)
      params["Signature"] = signature
      params
    end
    
    # URL Escape according to the AWS signature generation rules
    def self.escape(s)
      s.to_s.gsub(/([^a-zA-Z0-9_.~-]+)/n) {
        '%'+$1.unpack('H2'*$1.size).join('%').upcase
      }
    end
  end
end
