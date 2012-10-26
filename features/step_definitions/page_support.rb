Given /^I am viewing page entitled "(.*?)"$/ do |title|
  page.has_content?(title)
end

Given /^I follow link "(.*?)"$/ do |link|
  click_link(link)
end

