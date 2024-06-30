const assert = require('assert');
const websiteUrl = "https://witty-water-008de0c00.5.azurestaticapps.net"

// Navigate to the page
$browser.get(websiteUrl).then(function() {
  return $browser.waitForAndFindElement($driver.By.id('name'), 10000);
}).then(function(nameElement) {
  // Fill out the form with random values
  const randomName = `TestName${Math.floor(Math.random() * 1000)}`;
  const randomEmail = `test${Math.floor(Math.random() * 1000)}@example.com`;

  return nameElement.sendKeys(randomName).then(function() {
    return $browser.findElement($driver.By.id('email')).sendKeys(randomEmail);
  }).then(function() {
    // Submit the form
    return $browser.findElement($driver.By.className('form-submit')).click();
  });
}).then(function() {
  // Verify the form submission success message
  return $browser.waitForAndFindElement($driver.By.css('.form-container p'), 10000);
}).then(function(successMessage) {
  return successMessage.getText().then(function(text) {
    assert.equal(text, 'Thanks for getting in touch! We will respond to you as soon as possible.');
    // Set custom attribute for success
    $util.insights.set('formSubmissionSuccess', true);
  });
}).catch(function(err) {
  console.log(err);
  // Set custom attribute for failure
  $util.insights.set('formSubmissionSuccess', false);
  throw err;
});
