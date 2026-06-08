const fs = require('fs');

const managerId = '09d83eca-c37e-4d70-a7ca-8eee2a9dc157';
const storeCategories = [
  'Hair & styling', 'Nails', 'Eyebrows & lashes', 'Barber', 'Massage',
  'Spa & sauna', 'Tattooing & piercing', 'Makeup', 'Facial & skincare', 'Aesthetic'
];

const regions = [
  {
    province: 'Hà Nội',
    districts: ['Hoàn Kiếm', 'Đống Đa', 'Ba Đình', 'Hai Bà Trưng', 'Cầu Giấy', 'Tây Hồ'],
    bounds: { min_lat: 20.98, max_lat: 21.05, min_lng: 105.78, max_lng: 105.86 },
    weight: 14
  },
  {
    province: 'Hồ Chí Minh',
    districts: ['Quận 1', 'Quận 3', 'Quận 10', 'Bình Thạnh', 'Phú Nhuận', 'Tân Bình'],
    bounds: { min_lat: 10.75, max_lat: 10.82, min_lng: 106.65, max_lng: 106.72 },
    weight: 12
  },
  {
    province: 'Đà Nẵng',
    districts: ['Hải Châu', 'Sơn Trà', 'Ngũ Hành Sơn', 'Thanh Khê'],
    bounds: { min_lat: 16.05, max_lat: 16.08, min_lng: 108.20, max_lng: 108.24 },
    weight: 4
  }
];

const images = [
  'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'
];

const storeNamesPrefixes = ['The', 'Luxury', 'Premium', 'Royal', 'Elegance', 'Urban', 'Classic', 'Modern', 'Zen', 'Pure'];
const storeNamesSuffixes = ['Studio', 'Lounge', 'Lab', 'Center', 'Spa', 'Boutique', 'Room', 'House', 'Clinic', 'Corner'];

function escapeSql(val) {
  if (typeof val === 'string') {
    return "'" + val.replace(/'/g, "''") + "'";
  } else if (val === null || val === undefined) {
    return 'NULL';
  } else if (typeof val === 'boolean') {
    return val ? 'true' : 'false';
  } else {
    return String(val);
  }
}

function pickRandom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

function pickWeighted(arr) {
  let totalWeight = arr.reduce((sum, item) => sum + item.weight, 0);
  let rand = Math.random() * totalWeight;
  let current = 0;
  for (let item of arr) {
    current += item.weight;
    if (rand < current) return item;
  }
  return arr[arr.length - 1];
}

function randomDouble(min, max) {
  return min + Math.random() * (max - min);
}

const sql = [];
sql.push('DO $$');
sql.push('DECLARE');
sql.push('    v_store_id bigint;');
sql.push('    v_category_id bigint;');
sql.push('BEGIN');

for (let i = 1; i <= 30; i++) {
  const category = pickRandom(storeCategories);
  const regionChoice = pickWeighted(regions);
  const district = pickRandom(regionChoice.districts);
  
  const lat = randomDouble(regionChoice.bounds.min_lat, regionChoice.bounds.max_lat);
  const lng = randomDouble(regionChoice.bounds.min_lng, regionChoice.bounds.max_lng);
  
  const name = `${pickRandom(storeNamesPrefixes)} ${category.split(' ')[0]} ${pickRandom(storeNamesSuffixes)}`;
  const streets = ['Nguyễn Trãi', 'Lê Lợi', 'Trần Hưng Đạo', 'Lê Duẩn', 'Hai Bà Trưng', 'Nguyễn Huệ', 'Tôn Đức Thắng'];
  const address = `${Math.floor(Math.random() * 999) + 1} Đường ${pickRandom(streets)}`;
  const intro = `Chào mừng bạn đến với ${name}, nơi cung cấp các dịch vụ ${category} tốt nhất tại ${district}, ${regionChoice.province}.`;
  const email = `contact${i}@${name.replace(/ /g, '').toLowerCase()}.com`;
  const phone = `09${Math.floor(Math.random() * 90000000) + 10000000}`;
  const ratingNum = Math.floor(Math.random() * 491) + 10;
  const rating = parseFloat(randomDouble(4.0, 5.0).toFixed(1));
  const primaryImg = pickRandom(images);
  const storeType = pickRandom(['team', 'independent']);
  
  sql.push(`-- Store ${i}: ${name}`);
  sql.push(`
    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES (${escapeSql(name)}, ${escapeSql(address)}, ${escapeSql(district)}, ${escapeSql(regionChoice.province)}, 'Vietnam', ${escapeSql(intro)}, ${escapeSql(email)}, ${escapeSql(phone)}, ${ratingNum}, ${escapeSql(primaryImg)}, ${rating}, ${escapeSql(category)}, '${managerId}', '${storeType}', ST_SetSRID(ST_Point(${lng}, ${lat}), 4326), true)
    RETURNING id INTO v_store_id;
  `);

  sql.push('    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)');
  sql.push('    VALUES');
  const whValues = [];
  for (let day = 1; day <= 7; day++) {
    whValues.push(`    (v_store_id, ${day}, '08:00:00', '20:00:00', false)`);
  }
  sql.push(whValues.join(',\n') + ';');

  sql.push('    INSERT INTO store_images (store_id, image_url)');
  sql.push('    VALUES');
  const imgValues = [];
  for (let j = 0; j < 3; j++) {
    imgValues.push(`    (v_store_id, ${escapeSql(pickRandom(images))})`);
  }
  sql.push(imgValues.join(',\n') + ';');

  for (let catIdx = 0; catIdx < 2; catIdx++) {
    const subCatName = `${category} Category ${catIdx + 1}`;
    sql.push(`
    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, ${escapeSql(subCatName)}, 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    `);
    
    sql.push('    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)');
    sql.push('    VALUES');
    const srvValues = [];
    for (let srvIdx = 0; srvIdx < 3; srvIdx++) {
      const srvName = `Dịch vụ ${subCatName.split(' ')[0]} ${srvIdx + 1}`;
      const price = (Math.floor(Math.random() * 951) + 50) * 1000;
      const duration = pickRandom([30, 45, 60, 90, 120]);
      srvValues.push(`    (v_category_id, ${escapeSql(srvName)}, 'Mô tả dịch vụ chi tiết', ${price}, ${duration}, true, ${escapeSql(pickRandom(images))})`);
    }
    sql.push(srvValues.join(',\n') + ';');
  }
}

sql.push('END $$;');

fs.writeFileSync('c:/Android_Flutter/healia_app/insert_stores.sql', sql.join('\n'));
console.log('Generated insert_stores.sql successfully.');
