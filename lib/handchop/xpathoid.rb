module Xpathoid
  module_function

  def element(str)
    str == '' ? 'div' : str
  end

  def open_tag(str)
    return '<div>' if str.to_s.empty?
    xpath = str.split('.')
    tag = '<'
    tag += element(xpath[0])
    if xpath.size > 1
      tag += " class='#{xpath[1..-1].join(' ')}'"
    end
    tag += '>'
  end

  def close_tag(str)
    return '</div>' if str.to_s.empty?
    xpath = str.split('.')
    "</#{element(xpath[0])}>"
  end
end
