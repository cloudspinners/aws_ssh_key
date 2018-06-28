require 'aws-sdk'

module AwsSshKey

  class SecureParameter

    def self.client(region, arn_of_role_to_assume = nil)
      if arn_of_role_to_assume.nil?
        Aws::SSM::Client.new(
          region: region
        )
      else
        Aws::SSM::Client.new(
          region: region, 
          credentials: assumed_credentials(region, arn_of_role_to_assume)
        )
      end
    end

    def self.assumed_credentials(region, arn_of_role_to_assume)
      Aws::AssumeRoleCredentials.new(
        role_arn: arn_of_role_to_assume,
        role_session_name: 'aws_ssh_key'
      )
    end

    def self.get_parameter(name, region, arn_of_role_to_assume = nil)
      ssm = client(region, arn_of_role_to_assume)
      if parameter_exists?(name, region, arn_of_role_to_assume) then
        parameter = ssm.get_parameter({
          name: name,
          with_decryption: true,
        }).parameter
        parameter.value
      else
        nil
      end
    end

    def self.parameter_exists?(name, region, arn_of_role_to_assume = nil)
      ssm = client(region, arn_of_role_to_assume)
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

    def self.put_parameter(name, value, region, arn_of_role_to_assume, tags)
      ssm = client(region, arn_of_role_to_assume)
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
