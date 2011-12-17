module AreasHelper
  def AreasHelper.areas
    @@areas ||= Area.all.select { |b| b != Area.unspecified}.sort 
  end
end
