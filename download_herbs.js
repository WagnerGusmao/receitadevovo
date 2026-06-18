const fs = require('fs');
const path = require('path');
const https = require('https');

// Configurações de caminhos
const dataDir = path.join(__dirname, 'backend', 'app', 'Modules', 'Wellness', 'Database', 'Seeders', 'data');
const imagesDir = path.join(__dirname, 'frontend', 'public', 'images', 'herbs');

const jsonFiles = [
  path.join(dataDir, 'herbs_batch_1.json'),
  path.join(dataDir, 'herbs_batch_2.json'),
  path.join(dataDir, 'herbs_batch_3.json'),
];

// Garantir que a pasta de destino das imagens existe
if (!fs.existsSync(imagesDir)) {
  fs.mkdirSync(imagesDir, { recursive: true });
}

// Função auxiliar para fazer requisições HTTP GET que retornam JSON
function fetchJson(url) {
  return new Promise((resolve, reject) => {
    const headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'application/json',
    };

    https.get(url, { headers }, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(new Error(`Falha ao decodificar JSON de ${url}. Código de Status: ${res.statusCode}`));
        }
      });
    }).on('error', reject);
  });
}

// Função auxiliar para fazer download de uma imagem e salvá-la em arquivo
function downloadFile(url, destPath) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(destPath);
    https.get(url, (res) => {
      if (res.statusCode !== 200) {
        reject(new Error(`Falha no download da imagem. Código de Status: ${res.statusCode}`));
        return;
      }
      res.pipe(file);
      file.on('finish', () => {
        file.close();
        resolve();
      });
    }).on('error', (err) => {
      fs.unlink(destPath, () => {});
      reject(err);
    });
  });
}

// Função auxiliar para aguardar um determinado tempo (delay)
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function main() {
  console.log('=== INICIANDO O DOWNLOAD AUTÔNOMO DE FOTOS REALISTAS ===\n');

  for (const file of jsonFiles) {
    if (!fs.existsSync(file)) {
      console.log(`[AVISO] Arquivo não encontrado: ${path.basename(file)}`);
      continue;
    }

    console.log(`\nProcessando lote de dados: ${path.basename(file)}...`);
    const content = fs.readFileSync(file, 'utf8');
    const herbs = JSON.parse(content);
    let updatedCount = 0;

    for (let i = 0; i < herbs.length; i++) {
      const herb = herbs[i];
      
      // Só vamos baixar se a imagem ainda estiver apontada para a folha padrão
      if (herb.image_path !== '/images/herbs/folha.png') {
        console.log(`[PULAR] ${herb.name} já possui uma foto específica associada.`);
        continue;
      }

      console.log(`\n[BUSCANDO] Procurando foto de estúdio real para: ${herb.name} (${herb.scientific_name})...`);

      // 1. Tentar busca pelo nome científico botânico (altamente precisa)
      let query = `${herb.scientific_name} botanical`;
      let searchUrl = `https://unsplash.com/napi/search/photos?query=${encodeURIComponent(query)}&per_page=1`;
      
      let imageUrl = null;
      try {
        let res = await fetchJson(searchUrl);
        if (res.results && res.results.length > 0) {
          imageUrl = res.results[0].urls.regular;
          console.log(`  ✓ Foto botânica encontrada via nome científico.`);
        }
      } catch (err) {
        // Silencioso, tentará o fallback
      }

      // 2. Se falhar, tentar busca pelo nome comum em inglês/português
      if (!imageUrl) {
        query = `${herb.name} herb plant`;
        searchUrl = `https://unsplash.com/napi/search/photos?query=${encodeURIComponent(query)}&per_page=1`;
        try {
          let res = await fetchJson(searchUrl);
          if (res.results && res.results.length > 0) {
            imageUrl = res.results[0].urls.regular;
            console.log(`  ✓ Foto botânica encontrada via nome comum.`);
          }
        } catch (err) {
          // Silencioso
        }
      }

      // 3. Efetuar o download se encontramos a imagem
      if (imageUrl) {
        const destFileName = `${herb.slug}.png`;
        const destPath = path.join(imagesDir, destFileName);
        
        try {
          console.log(`  ↓ Efetuando download da imagem...`);
          await downloadFile(imageUrl, destPath);
          console.log(`  ✓ Imagem salva em: /images/herbs/${destFileName}`);
          
          // Atualiza o caminho da imagem no objeto herb
          herb.image_path = `/images/herbs/${destFileName}`;
          updatedCount++;
        } catch (err) {
          console.log(`  ❌ Erro ao baixar imagem para ${herb.name}: ${err.message}`);
        }
      } else {
        console.log(`  ⚠️ Nenhuma foto específica encontrada para ${herb.name}. Mantendo folha padrão.`);
      }

      // Pequeno delay de 400ms para evitar sobrecarga no servidor do Unsplash
      await sleep(400);
    }

    // Salvar as alterações de volta no arquivo JSON se houver atualizações
    if (updatedCount > 0) {
      fs.writeFileSync(file, JSON.stringify(herbs, null, 2), 'utf8');
      console.log(`\n[SALVO] Lote ${path.basename(file)} atualizado com ${updatedCount} novos caminhos de fotos.`);
    }
  }

  console.log('\n======================================================');
  console.log('✓ PROCESSO CONCLUÍDO! Todos os lotes de dados foram atualizados.');
  console.log('Execute agora a semeadura no banco de dados para consolidar as fotos:');
  console.log('  php artisan db:seed --class="App\\Modules\\Wellness\\Database\\Seeders\\WellnessSeeder"');
  console.log('======================================================');
}

main().catch(console.error);
