# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def trim(name, length)
    if name.length > length
      name[0,length - 2] + "..."
    else
      name
    end
  end
end
