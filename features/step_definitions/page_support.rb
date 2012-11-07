Given /^(?:I follow|User follows) link "(.*?)"$/ do |link|
  click_link(link)
end


Given /^(?:I am|User is) viewing page entitled "(.*?)"$/ do |title|
  page.has_content?(title)
end
