
#
# Secret Source
#

class SecretSource


  def secret_file_location
    @secret_file_location ||=
      begin
        possible_locations =
          ["~/var/secrets/encrypted_data_bag_secret",
           ::File.join(::File.dirname(__FILE__), '../../../', 'encrypted_data_bag_secret'),
         ].map {|file| ::File.expand_path(file) }
        found = possible_locations.find { |file| ::File.exist? file }

        unless found
          raise "Could not find a secrets file. Looked for it at: #{possible_locations}"
        end

        found
      end
  end

  def find_secret
    @found_secret ||=
      Chef::EncryptedDataBagItem.load_secret(secret_file_location)
  end

  def self.autofind
    new.find_secret
  end
end
