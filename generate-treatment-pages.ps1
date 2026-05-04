$ErrorActionPreference = 'Stop'
$root = 'C:\Users\pnmar\Documents\Codex\2026-04-23-doctype-html-html-lang-en-head'
$mainPath = Join-Path $root 'website-o1-dental-clinic.htm'
$source = [System.IO.File]::ReadAllText($mainPath)

function Get-PanelContent([string]$panelId) {
  $pattern = '<div class="content-panel" id="panel-' + [regex]::Escape($panelId) + '">[\s\S]*?<div class="panel-content">([\s\S]*?)</div>\s*</div>'
  $m = [regex]::Match($source, $pattern)
  if (-not $m.Success) { throw "Panel not found: $panelId" }
  return $m.Groups[1].Value.Trim()
}

$navLinks = [ordered]@{
  align = 'invisalign.html'
  lumineers = 'opseis-porselanis.html'
  whitening = 'leukansi-dontion.html'
  implants = 'emfitevmata-dontion.html'
  zirconia = 'stefanes-gefyres-zirkonias.html'
  composite = 'opseis-ritinis-bonding.html'
  inlays = 'keramika-entheta-epentheta.html'
  sealants = 'sfragismata-kai-prolipsi-teridonas.html'
  surgery = 'stomatiki-xeirourgiki.html'
}

$pages = @(
  @{ id='align'; file='invisalign.html'; title='Invisalign | 01 Dental Clinic'; description='Invisalign με ψηφιακο σχεδιασμο, iTero scanning και εξατομικευμενη παρακολουθηση απο το 01 Dental Clinic.' },
  @{ id='lumineers'; file='opseis-porselanis.html'; title='Οψεις Πορσελανης | 01 Dental Clinic'; description='Οψεις πορσελανης και Lumineers με ψηφιακο σχεδιασμο χαμογελου και φυσικο αισθητικο αποτελεσμα απο το 01 Dental Clinic.' },
  @{ id='whitening'; file='leukansi-dontion.html'; title='Λευκανση Δοντιων | 01 Dental Clinic'; description='Λευκανση δοντιων με ελεγχομενο clinical protocol, AirFlow preparation και εξατομικευμενο αισθητικο σχεδιασμο απο το 01 Dental Clinic.' },
  @{ id='implants'; file='emfitevmata-dontion.html'; title='Εμφυτευματα Δοντιων | 01 Dental Clinic'; description='Εμφυτευματα δοντιων με εξατομικευμενο σχεδιασμο, βιοσυμβατοτητα και αισθητικη ακριβεια απο το 01 Dental Clinic.' },
  @{ id='zirconia'; file='stefanes-gefyres-zirkonias.html'; title='Στεφανες και Γεφυρες Ζιρκονιας | 01 Dental Clinic'; description='Στεφανες και γεφυρες ζιρκονιας με ψηφιακη κατασκευη και φυσικο αισθητικο αποτελεσμα απο το 01 Dental Clinic.' },
  @{ id='composite'; file='opseis-ritinis-bonding.html'; title='Οψεις Ρητινης και Bonding | 01 Dental Clinic'; description='Οψεις ρητινης και bonding για αισθητικη βελτιωση του χαμογελου με συντηρητικη προσεγγιση απο το 01 Dental Clinic.' },
  @{ id='inlays'; file='keramika-entheta-epentheta.html'; title='Κεραμικα Ενθετα και Επενθετα | 01 Dental Clinic'; description='Κεραμικα ενθετα και επενθετα με CAD/CAM ακριβεια και βιομιμητικη λογικη απο το 01 Dental Clinic.' },
  @{ id='sealants'; file='sfragismata-kai-prolipsi-teridonas.html'; title='Σφραγισματα και Προληψη Τερηδονας | 01 Dental Clinic'; description='Σφραγισματα και προληψη τερηδονας με αισθητικες αποκαταστασεις και sealants απο το 01 Dental Clinic.' },
  @{ id='surgery'; file='stomatiki-xeirourgiki.html'; title='Στοματικη Χειρουργικη | 01 Dental Clinic'; description='Στοματικη χειρουργικη και οστικη αποκατασταση με συγχρονο σχεδιασμο και CBCT απο το 01 Dental Clinic.' }
)

function Build-TreatmentDropdown([string]$activeId) {
  $items = @(
    @{ key='align'; label='INVISALIGN / ALIGN' },
    @{ key='lumineers'; label='LUMINEERS / VENEERS' },
    @{ key='whitening'; label='WHITENING' },
    @{ key='implants'; label='IMPLANTS' },
    @{ key='zirconia'; label='ZIRCONIA CROWNS' },
    @{ key='composite'; label='COMPOSITE VENEERS' },
    @{ key='inlays'; label='INLAYS &amp; ONLAYS' },
    @{ key='sealants'; label='SEALANTS &amp; FILLINGS' },
    @{ key='surgery'; label='ORAL SURGERY' }
  )
  return (($items | ForEach-Object {
    $cls = if ($_.key -eq $activeId) { ' class="active"' } else { '' }
    '        <a href="' + $navLinks[$_.key] + '"' + $cls + '>' + $_.label + '</a>'
  }) -join "`r`n")
}

$template = @"
<!DOCTYPE html>
<html lang="el">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{{TITLE}}</title>
  <meta name="description" content="{{DESCRIPTION}}" />
  <link href="https://fonts.googleapis.com/css2?family=Jost:wght@200;300;400&family=Josefin+Sans:wght@100;300&display=swap" rel="stylesheet" />
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
    :root {
      --bg: #000;
      --text: #fff;
      --font: 'Josefin Sans', sans-serif;
      --body-font: 'Jost', sans-serif;
    }
    html, body { width: 100%; min-height: 100%; background: var(--bg); color: var(--text); font-family: var(--font); }
    body { overflow-x: hidden; }
    .wrapper { min-height: 100vh; min-height: 100svh; display: flex; flex-direction: column; background: #000; }
    .top { z-index: 10; display: flex; flex-direction: column; align-items: center; padding-top: clamp(2rem, 7vh, 5rem); gap: clamp(0.3rem, 1vh, 0.7rem); background: var(--bg); }
    .logo-img { width: clamp(115px, 22vw, 250px); height: auto; display: block; }
    nav { z-index: 20; display: flex; justify-content: space-between; align-items: flex-start; padding: clamp(1.2rem, 4vh, 3rem) clamp(1.2rem, 5vw, 5rem) clamp(0.8rem, 2vh, 1.5rem); background: var(--bg); position: relative; }
    .nav-item { position: relative; }
    nav a, .nav-trigger { color: rgba(255,255,255,0.58); text-decoration: none; font-family: var(--font); font-size: clamp(0.6rem, 1.2vw, 1rem); letter-spacing: 0.15em; font-weight: 100; text-transform: uppercase; cursor: pointer; background: none; border: none; padding: 0; transition: color 0.25s ease, opacity 0.25s ease; display: block; }
    nav a:hover, .nav-trigger:hover { color: rgba(255,255,255,0.82); opacity: 1; }
    nav a.active, .nav-trigger.active { color: #fff; opacity: 1; }
    .dropdown { position: absolute; top: calc(100% + 0.8rem); left: 0; display: none; flex-direction: column; gap: clamp(0.5rem, 1.5vh, 1rem); z-index: 30; background: var(--bg); padding: 0.5rem 0; }
    .dropdown.open { display: flex; }
    .dropdown a { font-size: clamp(0.55rem, 1.1vw, 0.9rem); letter-spacing: 0.12em; white-space: nowrap; opacity: 0.7; }
    .dropdown a.active { opacity: 1; color: #fff; }
    .page-content { flex: 1; padding: clamp(1.5rem, 5vw, 4rem) clamp(1.5rem, 6vw, 5rem) clamp(2rem, 5vw, 4rem); background: #000; }
    .panel-content { max-width: 1120px; margin: 0 auto; }
    .panel-content h1 { font-family: 'Jost', sans-serif; font-size: clamp(1.6rem, 4vw, 3.5rem); font-weight: 300; letter-spacing: 0.08em; margin-bottom: clamp(0.8rem, 2vh, 1.5rem); line-height: 1.15; text-transform: uppercase; }
    .panel-content h2 { font-family: 'Jost', sans-serif; font-size: clamp(0.95rem, 2vw, 1.6rem); font-weight: 400; letter-spacing: 0.12em; margin: clamp(1rem, 3vh, 2rem) 0 clamp(0.5rem, 1.5vh, 1rem); text-transform: uppercase; }
    .panel-content h3 { font-family: 'Jost', sans-serif; font-size: clamp(0.85rem, 1.6vw, 1.25rem); font-weight: 400; letter-spacing: 0.1em; margin: clamp(0.8rem, 2vh, 1.5rem) 0 clamp(0.4rem, 1vh, 0.8rem); text-transform: uppercase; }
    .panel-content p { font-family: 'Jost', sans-serif; font-size: clamp(0.85rem, 1.4vw, 1.1rem); font-weight: 300; line-height: 1.9; letter-spacing: 0.03em; margin-bottom: clamp(0.6rem, 1.5vh, 1rem); opacity: 0.85; }
    .panel-content ul { list-style: none; padding: 0; margin-bottom: clamp(0.6rem, 1.5vh, 1rem); }
    .panel-content ul li { font-family: 'Jost', sans-serif; font-size: clamp(0.85rem, 1.4vw, 1.1rem); font-weight: 300; line-height: 1.9; letter-spacing: 0.03em; opacity: 0.85; padding-left: 1rem; }
    .panel-content ul li::before { content: "— "; opacity: 0.5; }
    .panel-divider { width: 30px; height: 1px; background: rgba(255,255,255,0.25); margin: clamp(1rem, 3vh, 2rem) 0; }
    .treatment-carousel { margin: clamp(1.5rem, 4vh, 2.5rem) 0; }
    .treatment-carousel-track { display: flex; overflow-x: auto; overflow-y: hidden; scroll-snap-type: x mandatory; scroll-behavior: smooth; -webkit-overflow-scrolling: touch; scrollbar-width: none; touch-action: pan-x; }
    .treatment-carousel-track::-webkit-scrollbar { display: none; }
    .treatment-carousel-slide { flex: 0 0 100%; width: 100%; scroll-snap-align: start; background: #000; }
    .treatment-carousel-slide img { display: block; width: 100%; height: clamp(320px, 62vw, 620px); object-fit: cover; object-position: center; background: #000; }
    @media (min-width: 900px) { .top { padding-top: clamp(0.9rem, 3.6vh, 2.5rem); } nav { padding: clamp(0.65rem, 2vh, 1.35rem) clamp(1.2rem, 5vw, 5rem) clamp(0.45rem, 1.1vh, 0.8rem); } .treatment-carousel-slide img { object-fit: contain; } }
    .treatment-carousel-dots { display: flex; align-items: center; justify-content: center; gap: 0.55rem; margin-top: clamp(0.9rem, 2vh, 1.2rem); }
    .treatment-carousel-dot { width: 6px; height: 6px; border-radius: 50%; background: rgba(255,255,255,0.28); transition: background 0.2s ease, transform 0.2s ease; }
    .treatment-carousel-dot.active { background: #fff; transform: scale(1.15); }
  </style>
</head>
<body>
<div class="wrapper">
  <div class="top">
    <a href="index.html" aria-label="01 Dental Clinic home">
      <img class="logo-img" src="Untitled design (20).png" alt="01 Dental Clinic" />
    </a>
  </div>
  <nav>
    <div class="nav-item"><a href="about.html">ABOUT</a></div>
    <div class="nav-item">
      <button class="nav-trigger active" id="nav-treatments" onclick="toggleDropdown()">TREATMENTS</button>
      <div class="dropdown" id="treatments-dropdown">
{{DROPDOWN}}
      </div>
    </div>
    <div class="nav-item"><a href="contact.html">CONTACT</a></div>
    <div class="nav-item"><a href="request.html">REQUEST</a></div>
  </nav>
  <main class="page-content">
    <div class="panel-content">
{{CONTENT}}
    </div>
  </main>
</div>
<script>
  let dropdownOpen = false;
  function toggleDropdown() {
    dropdownOpen = !dropdownOpen;
    document.getElementById('treatments-dropdown').classList.toggle('open', dropdownOpen);
  }
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.nav-item')) {
      dropdownOpen = false;
      document.getElementById('treatments-dropdown').classList.remove('open');
    }
  });
  function initTreatmentCarousels() {
    document.querySelectorAll('[data-carousel]').forEach(function(carousel) {
      const track = carousel.querySelector('[data-carousel-track]');
      const dots = Array.from(carousel.querySelectorAll('.treatment-carousel-dot'));
      if (!track || dots.length === 0) return;
      let autoplayTimer = null;
      function updateDots() {
        const slideWidth = track.clientWidth || 1;
        const index = Math.max(0, Math.min(dots.length - 1, Math.round(track.scrollLeft / slideWidth)));
        dots.forEach(function(dot, dotIndex) { dot.classList.toggle('active', dotIndex === index); });
      }
      function getCurrentIndex() {
        const slideWidth = track.clientWidth || 1;
        return Math.max(0, Math.min(dots.length - 1, Math.round(track.scrollLeft / slideWidth)));
      }
      function stopAutoplay() { if (autoplayTimer) { window.clearInterval(autoplayTimer); autoplayTimer = null; } }
      function startAutoplay() {
        stopAutoplay();
        autoplayTimer = window.setInterval(function() {
          const nextIndex = (getCurrentIndex() + 1) % dots.length;
          track.scrollTo({ left: nextIndex * track.clientWidth, behavior: 'smooth' });
        }, 3000);
      }
      track.addEventListener('scroll', updateDots, { passive: true });
      window.addEventListener('resize', updateDots);
      updateDots();
      startAutoplay();
    });
  }
  initTreatmentCarousels();
</script>
</body>
</html>
"@

foreach ($page in $pages) {
  $content = Get-PanelContent $page.id
  $dropdown = Build-TreatmentDropdown $page.id
  $html = $template.Replace('{{TITLE}}', $page.title).Replace('{{DESCRIPTION}}', $page.description).Replace('{{DROPDOWN}}', $dropdown).Replace('{{CONTENT}}', $content)
  [System.IO.File]::WriteAllText((Join-Path $root $page.file), $html, [System.Text.UTF8Encoding]::new($true))
}

$sharedPages = @('about.html','contact.html','request.html','index.html','website-o1-dental-clinic.htm')
foreach ($name in $sharedPages) {
  $path = Join-Path $root $name
  if (-not (Test-Path $path)) { continue }
  $text = [System.IO.File]::ReadAllText($path)
  $text = [regex]::Replace($text, '<a href="[^"]*">INVISALIGN / ALIGN</a>','<a href="invisalign.html">INVISALIGN / ALIGN</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">LUMINEERS / VENEERS</a>','<a href="opseis-porselanis.html">LUMINEERS / VENEERS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">WHITENING</a>','<a href="leukansi-dontion.html">WHITENING</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">IMPLANTS</a>','<a href="emfitevmata-dontion.html">IMPLANTS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">ZIRCONIA CROWNS</a>','<a href="stefanes-gefyres-zirkonias.html">ZIRCONIA CROWNS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">COMPOSITE VENEERS</a>','<a href="opseis-ritinis-bonding.html">COMPOSITE VENEERS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">INLAYS &amp; ONLAYS</a>','<a href="keramika-entheta-epentheta.html">INLAYS &amp; ONLAYS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">SEALANTS &amp; FILLINGS</a>','<a href="sfragismata-kai-prolipsi-teridonas.html">SEALANTS &amp; FILLINGS</a>')
  $text = [regex]::Replace($text, '<a href="[^"]*">ORAL SURGERY</a>','<a href="stomatiki-xeirourgiki.html">ORAL SURGERY</a>')
  [System.IO.File]::WriteAllText($path, $text, [System.Text.UTF8Encoding]::new($true))
}

