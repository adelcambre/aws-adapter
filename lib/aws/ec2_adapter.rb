module Aws
  class Ec2Adapter < Adapter
    def initialize(*args)
      super
    end
    
    def describe_instances
      request("Action" => "DescribeInstances")
    end
  end
end