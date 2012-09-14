module Flarc

class IgcTmpFile < ActiveRecord::Base
  self.table_name = :igc_tmp_files

  belongs_to :pilot,
             :class_name => 'Flarc::Pilot'

  belongs_to :old_pilot,
             :class_name => 'Flarc::OldPilot'

  belongs_to :club

  after_create do
    File.open(self.filename, 'wb') do |f|
      @upload_filehandle.rewind
      f.write(@upload_filehandle.read)
    end

    @upload_filehandle = nil
  end

  after_destroy do
    begin
      File.delete(self.filename)
    rescue Errno::ENOENT
    end
  end

  def file=(file)
    @upload_filehandle = file
    self.original_filename = file.original_filename
  end

  def filename
    return File.join(Rails.root, 'db/igc_files', Rails.env, 'tmp', self.id.to_s + '.igc')
  end

  def igc_file
    @igc_file ||= IgcFile.open(self.filename, 'rb')
  end

  def encoded_polyline(options = {})
    GMapPolylineEncoder.new(:dp_threshold => 0.001).encode(
        self.igc_file.track.collect { |x| [x.lat, x.lon] })[:points]
  end
end


end
