require "aws_ssh_key/version"

module AwsSshKey

  class Key

    def initialize(key_path, key_name, aws_region)
      @key_path = key_path
      @key_name = key_name
      @aws_region = aws_region

      @secure_parameter_ssh_key_public = "#{key_path}/ssh_key/#{key_name}/public"
      @secure_parameter_ssh_key_private = "#{key_path}/ssh_key/#{key_name}/private"

      @public_key = nil
    end

    def load
      if @public_key.nil?
        @public_key = get_remote_public_key
      end
      if @public_key.nil?
        key_pair = generate_key
        put_remote_key_pair(key_pair)
        @public_key = key_pair
      end
      @key
    end

    def get_remote_public_key
      SecureParameter.get_parameter(@secure_parameter_ssh_key_public, @aws_region)
    end

    def generate_key
      KeyMaker.make_key(@key_name)
    end

    def put_remote_key_pair(key_pair)
      SecureParameter.put_parameter(@secure_parameter_ssh_key_public, key_pair[:public], @aws_region)
      SecureParameter.put_parameter(@secure_parameter_ssh_key_private, key_pair[:private], @aws_region)
      key_pair[:public]
    end

    def write(folder)
      mkpath folder
      File.open("#{folder}/#{@key_name}.pub", 'w') {|f| f.write(@public_key) }
    end

  end

end
