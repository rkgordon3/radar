module AreasHelper
  def AreasHelper.areas
    @@areas ||= Area.all.sort 
  end
end
