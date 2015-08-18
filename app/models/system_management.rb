class SystemManagement

  def self.get_system_info
    system_info = SystemInfo.new
    system_info.system_version = `uname -s -n -r -m -i` rescue 'N/A'
    system_info.application_version = MySite::Application::version
    system_info.ncpu = `cat /proc/cpuinfo | grep processor | wc -l` rescue 0
    system_info.ruby_version = `ruby -v` rescue 'N/A'
    physmem = `cat /proc/meminfo | grep MemTotal | grep [0-9]* -o` rescue 0
    if physmem
      system_info.physmem = physmem.to_i * 1024
    end

    return system_info
  end

  def self.get_storage_info
    storage_info = StorageInfo.new

    storage_info
  end

end

class SystemInfo < ActiveRecord::Base
  #field :system_version, type: String
  #field :application_version, type: String

  #field :ncpu, type: Integer
  #field :ruby_version, type: String
  #field :physmem, type: Integer
end

class StorageInfo < ActiveRecord::Base
  #field :db, type: Integer
  #field :db_total, type: Integer

  #field :projects, type: Integer, default: 0
  #field :tests, type: Integer, default: 0
  #field :total, type: Integer, default: 0

  def all_collections_info

  end
end