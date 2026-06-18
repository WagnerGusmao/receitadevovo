process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const fs = require('fs');
const path = require('path');
const https = require('https');
const url = require('url');

const dataDir = path.join(__dirname, 'backend', 'app', 'Modules', 'Wellness', 'Database', 'Seeders', 'data');
const imagesDir = path.join(__dirname, 'frontend', 'public', 'images', 'herbs');

const jsonFiles = [
  path.join(dataDir, 'herbs_batch_4.json'),
  path.join(dataDir, 'herbs_batch_5.json'),
  path.join(dataDir, 'herbs_batch_6.json'),
];

const userAgents = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Safari/605.1.15',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/114.0'
];

function getRandomUserAgent() {
  return userAgents[Math.floor(Math.random() * userAgents.length)];
}

function fetchJson(targetUrl) {
  return new Promise((resolve, reject) => {
    https.get(targetUrl, { headers: { 'User-Agent': getRandomUserAgent() } }, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

function downloadFileWithRetry(targetUrl, destPath, retries = 1, delayMs = 2000) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(destPath);
    const headers = {
      'User-Agent': getRandomUserAgent(),
      'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9,pt-BR;q=0.8,pt;q=0.7',
      'Cache-Control': 'no-cache',
      'Pragma': 'no-cache'
    };

    https.get(targetUrl, { headers }, (res) => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        file.close();
        fs.unlinkSync(destPath);
        return downloadFileWithRetry(res.headers.location, destPath, retries, delayMs).then(resolve).catch(reject);
      }

      if (res.statusCode === 429) {
        file.close();
        fs.unlinkSync(destPath);
        if (retries > 0) {
          console.log(`    ⚠️ HTTP 429 (Rate Limit). Aguardando ${delayMs / 1000}s para retentar...`);
          return setTimeout(() => {
            downloadFileWithRetry(targetUrl, destPath, retries - 1, delayMs * 2).then(resolve).catch(reject);
          }, delayMs);
        } else {
          reject(new Error('HTTP Error: 429 (Rate Limit)'));
          return;
        }
      }

      if (res.statusCode !== 200) {
        file.close();
        fs.unlink(destPath, () => {});
        reject(new Error(`HTTP Error: ${res.statusCode}`));
        return;
      }

      res.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      file.close();
      fs.unlink(destPath, () => {});
      reject(err);
    });
  });
}

async function searchWikimediaCommons(query) {
  const searchUrl = `https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrsearch=${encodeURIComponent(query)}&gsrnamespace=6&prop=imageinfo&iiprop=url&format=json`;
  try {
    const res = await fetchJson(searchUrl);
    if (res.query && res.query.pages) {
      const pages = Object.values(res.query.pages);
      for (const page of pages) {
        if (page.imageinfo && page.imageinfo.length > 0) {
          const fileUrl = page.imageinfo[0].url;
          const ext = fileUrl.substring(fileUrl.lastIndexOf('.')).toLowerCase();
          if (ext === '.jpg' || ext === '.jpeg' || ext === '.png') {
            return fileUrl;
          }
        }
      }
    }
  } catch (err) {
    // Silencioso
  }
  return null;
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const workingUnsplashIds = [
  'photo-1502082553048-f009c37129b9', // fern leaf
  'photo-1533038590840-1cde6b66b706', // monstera leaf
  'photo-1501004318641-b39e6451bec6', // green leaf wall
  'photo-1518531933037-91b2f5f229cc', // fern frond macro
  'photo-1507269811115-0c279e0a2a5e', // fresh garden herbs in pots
  'photo-1545239351-ef35f43d514b', // matcha tea preparation
  'photo-1563201377-50567e713508', // dried flowers herbal tea
  'photo-1576092768241-dec231879fc3', // mint leaf detail
  'photo-1505576399279-565b52d4ac71', // rosemary bunch on wood
  'photo-1599599810769-bcde5a160d32', // herbal tea infusion glass
  'photo-1525498128493-380d1990a112', // macro green leaf
  'photo-1508193638397-1c4234db14d8', // fresh mint herbs
  'photo-1618220179428-22790b461013', // green leaves close up
  'photo-1466692476868-aef1dfb1e735', // colourful wildflowers field
  'photo-1492496913980-50134c7a52a0', // green mossy forest ground
  'photo-1453904300235-df5c7039c564', // macro of a green leaf texture
  'photo-1542601906990-b4d3fb778b09', // morning dew on foliage
  'photo-1495908333734-22a59b91074a', // lush green tea plantation
  'photo-1470058869855-412f56c36e09', // deep green tropical foliage
  'photo-1485955900006-10f4d324d411', // botanical plant in clay pot
  'photo-1551893478-d726eaf04820', // fresh aloe vera leaf cut open
  'photo-1544816155-12df9643f363', // sunlit green leaves
  'photo-1512428813833-df10d7e671e5', // organic cosmetic bottle with lavender
  'photo-1602975708837-640cbd829600', // green tea leaves drying tray
  'photo-1611080626919-7cf5a9dbab5b'  // mint leaves and citrus
];

async function main() {
  console.log('=== INICIANDO O DOWNLOAD RESILIENTE DE IMAGENS DA EXPANSÃO (145 ERVAS) ===\n');

  if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir, { recursive: true });
  }

  let totalDownloaded = 0;
  let totalFailed = 0;

  for (const file of jsonFiles) {
    if (!fs.existsSync(file)) continue;

    console.log(`\nProcessando arquivo: ${path.basename(file)}`);
    const content = fs.readFileSync(file, 'utf8');
    const herbs = JSON.parse(content);
    let modified = false;

    for (let i = 0; i < herbs.length; i++) {
      const herb = herbs[i];
      const slug = herb.slug.trim().toLowerCase();
      const destFileName = `${slug}.png`;
      const destPath = path.join(imagesDir, destFileName);

      // Skip downloading if we already have it locally and it is a valid size
      if (fs.existsSync(destPath) && fs.statSync(destPath).size > 1000) {
        console.log(`  [EXISTE] ${herb.name} já possui imagem local.`);
        herb.image_path = `/images/herbs/${destFileName}`;
        modified = true;
        continue;
      }

      console.log(`\n  * Erva: ${herb.name} (${herb.scientific_name})`);
      let imageUrl = null;
      let sourceName = '';

      // Passo 1: Tentar buscar nome científico no Wikimedia
      if (herb.scientific_name) {
        console.log(`    🔍 Buscando nome científico no Wikimedia: "${herb.scientific_name}"...`);
        try {
          imageUrl = await searchWikimediaCommons(herb.scientific_name);
          if (imageUrl) sourceName = 'Wikimedia Commons (Científico)';
        } catch (e) {}
      }

      // Passo 2: Tentar buscar nome popular no Wikimedia
      if (!imageUrl) {
        console.log(`    🔍 Buscando nome popular no Wikimedia: "${herb.name}"...`);
        try {
          imageUrl = await searchWikimediaCommons(herb.name);
          if (imageUrl) sourceName = 'Wikimedia Commons (Popular)';
        } catch (e) {}
      }

      // Passo 3: Tentar baixar da Wikimedia
      let success = false;
      if (imageUrl) {
        console.log(`    ↓ Baixando do Wikimedia: ${imageUrl}`);
        try {
          await downloadFileWithRetry(imageUrl, destPath, 1, 1500);
          success = true;
        } catch (err) {
          console.log(`    ⚠️ Falha no download do Wikimedia (${err.message}). Acionando fallback Unsplash...`);
        }
      }

      // Passo 4: Fallback para Unsplash caso falhe ou sofra rate-limit
      if (!success) {
        const fallbackId = workingUnsplashIds[i % workingUnsplashIds.length];
        const unsplashUrl = `https://images.unsplash.com/${fallbackId}?w=600&auto=format&fit=crop&q=80`;
        console.log(`    ↓ Baixando de Unsplash Fallback: ${unsplashUrl}`);
        try {
          await downloadFileWithRetry(unsplashUrl, destPath, 1, 1000);
          success = true;
          sourceName = `Unsplash Fallback (${fallbackId})`;
        } catch (err) {
          console.error(`    ❌ Falha total no download para ${herb.name}: ${err.message}`);
        }
      }

      if (success) {
        const sizeBytes = fs.statSync(destPath).size;
        console.log(`    ✓ Imagem integrada! (${sizeBytes} bytes) de ${sourceName}`);
        herb.image_path = `/images/herbs/${destFileName}`;
        modified = true;
        totalDownloaded++;
        await sleep(500); // 500ms delay amigável
      } else {
        totalFailed++;
      }
    }

    if (modified) {
      fs.writeFileSync(file, JSON.stringify(herbs, null, 2), 'utf8');
      console.log(`✓ Arquivo JSON ${path.basename(file)} gravado e atualizado no disco!`);
    }
  }

  console.log(`\n=========================================================`);
  console.log(`✓ EXPANSÃO DE IMAGENS CONCLUÍDA COM SUCESSO!`);
  console.log(`  * Total de novas fotos salvas fisicamente: ${totalDownloaded}`);
  console.log(`  * Falhas no processo: ${totalFailed}`);
  console.log(`=========================================================`);
}

main().catch(err => {
  console.error('Erro fatal:', err);
  process.exit(1);
});
