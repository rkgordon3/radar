And(/^the user selects "(.*?)" from the auto-suggestion field$/) do |selection|
 	page.find(:xpath, "//li[@class='ui-menu-item']/a['#{selection}']").click
end