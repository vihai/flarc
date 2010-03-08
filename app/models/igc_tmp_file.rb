class IgcTmpFile < ActiveRecord::Base

  belongs_to :pilot
  belongs_to :club

  def after_find
  end

  def file=(file)
    @upload_filehandle = file
    self.original_filename = file.original_filename
  end

  def after_create
    File.open(self.filename, "wb") do |f| 
      @upload_filehandle.rewind
      f.write(@upload_filehandle.read)
    end

    @upload_filehandle.close
    @upload_filehandle = nil
  end

  def after_destroy
    begin
      File.delete(self.filename)
    rescue Errno::ENOENT
    end
  end

  def filename
    return File.join(Rails.root, "data", Rails.env, "igc_tmp_files", self.id.to_s + ".igc")
  end
end
