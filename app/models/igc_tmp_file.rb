class IgcTmpFile < ActiveRecord::Base

  belongs_to :pilot
  belongs_to :club

  after_create :my_after_create
  after_destroy :my_after_destroy

  def file=(file)
    @upload_filehandle = file
    self.original_filename = file.original_filename
  end

  def my_after_create
    File.open(self.filename, "wb") do |f| 
      @upload_filehandle.rewind
      f.write(@upload_filehandle.read)
    end

    @upload_filehandle.close
    @upload_filehandle = nil
  end

  def my_after_destroy
    begin
      File.delete(self.filename)
    rescue Errno::ENOENT
    end
  end

  def filename
    return File.join(Rails.root, "data", Rails.env, "igc_tmp_files", self.id.to_s + ".igc")
  end
end
