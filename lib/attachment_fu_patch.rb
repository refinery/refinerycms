# This patches the windows tempfile problem that attachment_fu depends on. See:
# http://epirsch.blogspot.com/2008/01/fixing-attachmentfu-on-windows-like.html

require 'tempfile'

class Tempfile
  def size
    if @tmpfile
      @tmpfile.fsync # added this line
      @tmpfile.flush
      @tmpfile.stat.size
    else
      0
    end
  end
end
