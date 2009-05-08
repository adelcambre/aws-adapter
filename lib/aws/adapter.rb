require 'curb'

module Aws
  class Adapter
    def initialize(aws_access_key_id, aws_secret_access_key, host="https://ec2.amazonaws.com/")
      @aws_access_key_id, @aws_secret_access_key, @host = aws_access_key_id, aws_secret_access_key, host
    end
    
    def request(params)
      params["AWSAccessKeyId"] = @aws_access_key_id
      query_string = Signature.signed_query_params(@host, params, @aws_secret_access_key).map{ |k,v|
        "#{Signature.escape(k)}=#{Signature.escape(v)}"
      } * "&"
      url = "#{@host}?#{query_string}"
      Curl::Easy.http_get(url).body_str
    end
  end
end