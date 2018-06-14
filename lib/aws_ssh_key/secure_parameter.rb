require 'aws-sdk'

module AwsSshKey

  class SecureParameter
    def self.get_parameter(name, region)
      ssm = Aws::SSM::Client.new(region: region)
      if parameter_exists?(name, region) then
        parameter = ssm.get_parameter({
          name: name,
          with_decryption: true,
        }).parameter
        parameter.value
      else
        nil
      end
    end

    def self.parameter_exists?(name, region)
      ssm = Aws::SSM::Client.new(region: region)
      parameters = ssm.describe_parameters({
        filters: [
          {
            key: "Name",
            values: [name]
          }
        ]
      }).parameters
      parameters.size > 0
    end

    def self.put_parameter(name, value, region, tags)
      ssm = Aws::SSM::Client.new(region: region)
      ssm.put_parameter({
        name: name,
        value: value,
        type: "SecureString",
        overwrite: true
      })

      unless tags.empty?
        tag_list = tags.map { |key, value|
          { key: key, value: value }
        }

        resp = ssm.add_tags_to_resource({
          resource_type: 'Parameter',
          resource_id: name,
          tags: tag_list
        })
      end
    end

  end

end
