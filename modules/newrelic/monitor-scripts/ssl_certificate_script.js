const https = require('https');

function getSSLCertificate(url, callback) {
  const req = https.get(url, (res) => {
    const certificate = res.connection.getPeerCertificate();
    callback(null, certificate);
  });

  req.on('error', (err) => {
    callback(err, null);
  });

  req.end();
}

const websiteUrl = "https://witty-water-008de0c00.5.azurestaticapps.net"
getSSLCertificate(websiteUrl, (err, cert) => {
  if (err) {
    console.log('Error fetching certificate:', err);
    $util.insights.set('daysToExpiry', -1);
  } else {
    const expiryDate = new Date(cert.valid_to);
    const currentDate = new Date();
    const daysToExpiry = Math.floor((expiryDate - currentDate) / (1000 * 60 * 60 * 24));
    console.log('Days to certificate expiry:', daysToExpiry);

    // Set the value for NRQL query
    $util.insights.set('daysToExpiry', daysToExpiry);
  }
});
