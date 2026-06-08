DO $$
DECLARE
    v_store_id bigint;
    v_category_id bigint;
BEGIN
-- Store 1: Classic Makeup Spa

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Classic Makeup Spa', '460 Đường Lê Lợi', 'Hoàn Kiếm', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Classic Makeup Spa, nơi cung cấp các dịch vụ Makeup tốt nhất tại Hoàn Kiếm, Hà Nội.', 'contact1@classicmakeupspa.com', '0925056452', 267, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop', 4.1, 'Makeup', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(105.8269868881115, 21.03658873495683), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 448000, 30, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 730000, 60, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 133000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 121000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 263000, 60, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 504000, 45, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');
-- Store 2: Urban Aesthetic Corner

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Aesthetic Corner', '617 Đường Trần Hưng Đạo', 'Quận 1', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Urban Aesthetic Corner, nơi cung cấp các dịch vụ Aesthetic tốt nhất tại Quận 1, Hồ Chí Minh.', 'contact2@urbanaestheticcorner.com', '0949879563', 14, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop', 4.6, 'Aesthetic', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.71395805271821, 10.772985646116682), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 124000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 330000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 858000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 878000, 90, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 412000, 30, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 968000, 90, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');
-- Store 3: Zen Facial Lab

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Zen Facial Lab', '940 Đường Trần Hưng Đạo', 'Tân Bình', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Zen Facial Lab, nơi cung cấp các dịch vụ Facial & skincare tốt nhất tại Tân Bình, Hồ Chí Minh.', 'contact3@zenfaciallab.com', '0965963284', 85, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.6, 'Facial & skincare', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.68903727576819, 10.77658362127924), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 351000, 90, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 541000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 798000, 45, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 230000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 359000, 120, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 194000, 45, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');
-- Store 4: Royal Makeup Studio

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Royal Makeup Studio', '689 Đường Trần Hưng Đạo', 'Ngũ Hành Sơn', 'Đà Nẵng', 'Vietnam', 'Chào mừng bạn đến với Royal Makeup Studio, nơi cung cấp các dịch vụ Makeup tốt nhất tại Ngũ Hành Sơn, Đà Nẵng.', 'contact4@royalmakeupstudio.com', '0955087872', 449, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.5, 'Makeup', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(108.21716905871651, 16.06467377926942), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 581000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 759000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 122000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 873000, 120, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 645000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 247000, 45, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 5: Elegance Facial Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Elegance Facial Room', '863 Đường Hai Bà Trưng', 'Ba Đình', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Elegance Facial Room, nơi cung cấp các dịch vụ Facial & skincare tốt nhất tại Ba Đình, Hà Nội.', 'contact5@elegancefacialroom.com', '0924552061', 311, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop', 4.3, 'Facial & skincare', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.79212894305952, 21.015339400032204), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 549000, 60, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 799000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 146000, 45, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 489000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 954000, 45, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 215000, 45, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 6: Royal Makeup Studio

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Royal Makeup Studio', '779 Đường Trần Hưng Đạo', 'Hai Bà Trưng', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Royal Makeup Studio, nơi cung cấp các dịch vụ Makeup tốt nhất tại Hai Bà Trưng, Hà Nội.', 'contact6@royalmakeupstudio.com', '0948437275', 239, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop', 4.4, 'Makeup', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(105.79360454829889, 21.032553348802022), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 54000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 249000, 60, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 452000, 90, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 410000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 721000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 989000, 90, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');
-- Store 7: Urban Hair House

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Hair House', '507 Đường Lê Duẩn', 'Ba Đình', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Urban Hair House, nơi cung cấp các dịch vụ Hair & styling tốt nhất tại Ba Đình, Hà Nội.', 'contact7@urbanhairhouse.com', '0983509830', 436, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop', 4.1, 'Hair & styling', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(105.79265752810808, 21.001349340627076), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 843000, 120, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 162000, 30, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 965000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 846000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 915000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 673000, 60, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 8: Urban Massage Lounge

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Massage Lounge', '301 Đường Tôn Đức Thắng', 'Ba Đình', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Urban Massage Lounge, nơi cung cấp các dịch vụ Massage tốt nhất tại Ba Đình, Hà Nội.', 'contact8@urbanmassagelounge.com', '0929923969', 364, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.3, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.8184551962532, 21.0213301589891), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 276000, 90, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 743000, 30, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 969000, 120, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 126000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 755000, 120, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 636000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');
-- Store 9: Royal Nails Lounge

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Royal Nails Lounge', '847 Đường Lê Duẩn', 'Quận 10', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Royal Nails Lounge, nơi cung cấp các dịch vụ Nails tốt nhất tại Quận 10, Hồ Chí Minh.', 'contact9@royalnailslounge.com', '0967947440', 14, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.6, 'Nails', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(106.71831291522867, 10.81763620272377), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 567000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 214000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 627000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 822000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 593000, 120, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 960000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');
-- Store 10: Royal Nails House

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Royal Nails House', '823 Đường Nguyễn Huệ', 'Ba Đình', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Royal Nails House, nơi cung cấp các dịch vụ Nails tốt nhất tại Ba Đình, Hà Nội.', 'contact10@royalnailshouse.com', '0979604983', 119, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop', 4.6, 'Nails', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(105.79415499893179, 21.00117076158631), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 209000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 555000, 30, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 673000, 120, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 465000, 30, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 824000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 481000, 90, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');
-- Store 11: Royal Hair Center

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Royal Hair Center', '691 Đường Trần Hưng Đạo', 'Quận 1', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Royal Hair Center, nơi cung cấp các dịch vụ Hair & styling tốt nhất tại Quận 1, Hồ Chí Minh.', 'contact11@royalhaircenter.com', '0970714271', 249, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.1, 'Hair & styling', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(106.70041414225258, 10.760865950495807), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 893000, 30, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 242000, 120, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 548000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 522000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 999000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 720000, 120, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');
-- Store 12: Urban Barber Lounge

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Barber Lounge', '798 Đường Hai Bà Trưng', 'Quận 3', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Urban Barber Lounge, nơi cung cấp các dịch vụ Barber tốt nhất tại Quận 3, Hồ Chí Minh.', 'contact12@urbanbarberlounge.com', '0938751040', 416, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop', 4, 'Barber', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(106.69370810756101, 10.777037706025876), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Barber Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Barber 1', 'Mô tả dịch vụ chi tiết', 296000, 45, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Barber 2', 'Mô tả dịch vụ chi tiết', 251000, 60, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Barber 3', 'Mô tả dịch vụ chi tiết', 549000, 60, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Barber Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Barber 1', 'Mô tả dịch vụ chi tiết', 516000, 90, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Barber 2', 'Mô tả dịch vụ chi tiết', 843000, 30, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Barber 3', 'Mô tả dịch vụ chi tiết', 156000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');
-- Store 13: Pure Facial Corner

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Pure Facial Corner', '192 Đường Nguyễn Trãi', 'Hai Bà Trưng', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Pure Facial Corner, nơi cung cấp các dịch vụ Facial & skincare tốt nhất tại Hai Bà Trưng, Hà Nội.', 'contact13@purefacialcorner.com', '0930281920', 294, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop', 4.3, 'Facial & skincare', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.85768189099093, 21.048190180236166), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 70000, 30, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 452000, 90, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 776000, 120, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Facial & skincare Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Facial 1', 'Mô tả dịch vụ chi tiết', 162000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 2', 'Mô tả dịch vụ chi tiết', 536000, 30, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Facial 3', 'Mô tả dịch vụ chi tiết', 664000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');
-- Store 14: Pure Tattooing Boutique

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Pure Tattooing Boutique', '46 Đường Tôn Đức Thắng', 'Hai Bà Trưng', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Pure Tattooing Boutique, nơi cung cấp các dịch vụ Tattooing & piercing tốt nhất tại Hai Bà Trưng, Hà Nội.', 'contact14@puretattooingboutique.com', '0916961200', 244, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop', 4.5, 'Tattooing & piercing', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.79542370140825, 21.03341631950588), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 813000, 30, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 390000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 374000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 257000, 90, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 203000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 202000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');
-- Store 15: Urban Spa Center

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Spa Center', '486 Đường Trần Hưng Đạo', 'Sơn Trà', 'Đà Nẵng', 'Vietnam', 'Chào mừng bạn đến với Urban Spa Center, nơi cung cấp các dịch vụ Spa & sauna tốt nhất tại Sơn Trà, Đà Nẵng.', 'contact15@urbanspacenter.com', '0992514780', 273, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop', 4.9, 'Spa & sauna', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(108.20284780033133, 16.058113764512107), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 464000, 30, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 310000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 103000, 30, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 253000, 45, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 671000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 120000, 60, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');
-- Store 16: Premium Aesthetic Boutique

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Premium Aesthetic Boutique', '362 Đường Lê Lợi', 'Quận 3', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Premium Aesthetic Boutique, nơi cung cấp các dịch vụ Aesthetic tốt nhất tại Quận 3, Hồ Chí Minh.', 'contact16@premiumaestheticboutique.com', '0912491401', 452, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop', 4.6, 'Aesthetic', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.65992254152344, 10.767140625925638), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 160000, 30, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 982000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 406000, 30, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 459000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 700000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 409000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');
-- Store 17: Luxury Hair Corner

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Luxury Hair Corner', '126 Đường Nguyễn Huệ', 'Quận 3', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Luxury Hair Corner, nơi cung cấp các dịch vụ Hair & styling tốt nhất tại Quận 3, Hồ Chí Minh.', 'contact17@luxuryhaircorner.com', '0936451265', 72, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop', 4.6, 'Hair & styling', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.65543500076956, 10.799477936014416), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 384000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 245000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 669000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Hair & styling Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Hair 1', 'Mô tả dịch vụ chi tiết', 817000, 120, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 2', 'Mô tả dịch vụ chi tiết', 112000, 60, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Hair 3', 'Mô tả dịch vụ chi tiết', 878000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');
-- Store 18: Classic Nails Studio

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Classic Nails Studio', '860 Đường Trần Hưng Đạo', 'Tây Hồ', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Classic Nails Studio, nơi cung cấp các dịch vụ Nails tốt nhất tại Tây Hồ, Hà Nội.', 'contact18@classicnailsstudio.com', '0940326716', 263, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', 4.8, 'Nails', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(105.80754354857598, 21.034268732584152), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 475000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 507000, 90, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 332000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Nails Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Nails 1', 'Mô tả dịch vụ chi tiết', 376000, 120, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 2', 'Mô tả dịch vụ chi tiết', 922000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Nails 3', 'Mô tả dịch vụ chi tiết', 690000, 120, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');
-- Store 19: The Spa Center

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('The Spa Center', '549 Đường Lê Lợi', 'Quận 3', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với The Spa Center, nơi cung cấp các dịch vụ Spa & sauna tốt nhất tại Quận 3, Hồ Chí Minh.', 'contact19@thespacenter.com', '0947209112', 297, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop', 4.2, 'Spa & sauna', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.6541328980353, 10.753152598197646), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 527000, 30, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 771000, 45, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 870000, 45, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 275000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 272000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 860000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');
-- Store 20: Elegance Spa Lounge

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Elegance Spa Lounge', '258 Đường Hai Bà Trưng', 'Tân Bình', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Elegance Spa Lounge, nơi cung cấp các dịch vụ Spa & sauna tốt nhất tại Tân Bình, Hồ Chí Minh.', 'contact20@elegancespalounge.com', '0928870335', 380, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 4.5, 'Spa & sauna', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(106.67022946777418, 10.771787999487875), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 789000, 30, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 156000, 120, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 243000, 120, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Spa & sauna Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Spa 1', 'Mô tả dịch vụ chi tiết', 273000, 45, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 2', 'Mô tả dịch vụ chi tiết', 729000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Spa 3', 'Mô tả dịch vụ chi tiết', 454000, 30, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');
-- Store 21: Classic Massage House

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Classic Massage House', '554 Đường Trần Hưng Đạo', 'Thanh Khê', 'Đà Nẵng', 'Vietnam', 'Chào mừng bạn đến với Classic Massage House, nơi cung cấp các dịch vụ Massage tốt nhất tại Thanh Khê, Đà Nẵng.', 'contact21@classicmassagehouse.com', '0963689031', 450, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', 5, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(108.2173671212366, 16.06575645337002), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 908000, 60, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 820000, 30, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 382000, 45, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 419000, 30, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 334000, 60, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 754000, 90, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 22: Urban Massage Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Massage Room', '658 Đường Lê Duẩn', 'Ba Đình', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Urban Massage Room, nơi cung cấp các dịch vụ Massage tốt nhất tại Ba Đình, Hà Nội.', 'contact22@urbanmassageroom.com', '0953178250', 175, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', 4.1, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.81187800888071, 21.02082393610996), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 886000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 752000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 204000, 45, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 694000, 120, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 606000, 45, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 658000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');
-- Store 23: Elegance Tattooing Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Elegance Tattooing Room', '673 Đường Hai Bà Trưng', 'Cầu Giấy', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Elegance Tattooing Room, nơi cung cấp các dịch vụ Tattooing & piercing tốt nhất tại Cầu Giấy, Hà Nội.', 'contact23@elegancetattooingroom.com', '0973905856', 449, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop', 4.4, 'Tattooing & piercing', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.8586708912473, 21.045401058685805), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 528000, 60, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 388000, 120, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 613000, 90, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 141000, 90, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 81000, 120, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 931000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');
-- Store 24: Modern Tattooing Lounge

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Modern Tattooing Lounge', '168 Đường Trần Hưng Đạo', 'Quận 3', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với Modern Tattooing Lounge, nơi cung cấp các dịch vụ Tattooing & piercing tốt nhất tại Quận 3, Hồ Chí Minh.', 'contact24@moderntattooinglounge.com', '0917450976', 234, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop', 4.6, 'Tattooing & piercing', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(106.66401915125414, 10.796572002365648), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 868000, 120, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 627000, 30, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 178000, 45, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Tattooing & piercing Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Tattooing 1', 'Mô tả dịch vụ chi tiết', 333000, 90, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 2', 'Mô tả dịch vụ chi tiết', 901000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Tattooing 3', 'Mô tả dịch vụ chi tiết', 932000, 60, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');
-- Store 25: Luxury Massage Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Luxury Massage Room', '439 Đường Lê Duẩn', 'Cầu Giấy', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Luxury Massage Room, nơi cung cấp các dịch vụ Massage tốt nhất tại Cầu Giấy, Hà Nội.', 'contact25@luxurymassageroom.com', '0934876552', 275, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop', 4.9, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.8451377019653, 20.983713810591603), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 470000, 60, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 778000, 60, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 993000, 30, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 715000, 90, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 354000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 349000, 60, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');
-- Store 26: Classic Massage Spa

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Classic Massage Spa', '186 Đường Lê Duẩn', 'Hai Bà Trưng', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Classic Massage Spa, nơi cung cấp các dịch vụ Massage tốt nhất tại Hai Bà Trưng, Hà Nội.', 'contact26@classicmassagespa.com', '0975185896', 30, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop', 5, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.83045044767276, 21.042956216753748), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 732000, 90, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 666000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 203000, 30, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 997000, 60, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 924000, 30, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 540000, 120, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 27: The Massage House

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('The Massage House', '914 Đường Hai Bà Trưng', 'Phú Nhuận', 'Hồ Chí Minh', 'Vietnam', 'Chào mừng bạn đến với The Massage House, nơi cung cấp các dịch vụ Massage tốt nhất tại Phú Nhuận, Hồ Chí Minh.', 'contact27@themassagehouse.com', '0967234508', 440, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop', 4.5, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(106.71360150486329, 10.794726087425806), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 164000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 126000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 78000, 60, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 544000, 90, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 731000, 90, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 668000, 90, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 28: Modern Aesthetic Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Modern Aesthetic Room', '367 Đường Nguyễn Trãi', 'Thanh Khê', 'Đà Nẵng', 'Vietnam', 'Chào mừng bạn đến với Modern Aesthetic Room, nơi cung cấp các dịch vụ Aesthetic tốt nhất tại Thanh Khê, Đà Nẵng.', 'contact28@modernaestheticroom.com', '0943332477', 471, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop', 4.5, 'Aesthetic', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'independent', ST_SetSRID(ST_Point(108.22331770977368, 16.064450212743864), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 470000, 90, true, 'https://images.unsplash.com/photo-1521590832167-7bfcfaa6362f?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 185000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 898000, 120, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Aesthetic Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Aesthetic 1', 'Mô tả dịch vụ chi tiết', 363000, 90, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 2', 'Mô tả dịch vụ chi tiết', 846000, 90, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Aesthetic 3', 'Mô tả dịch vụ chi tiết', 325000, 60, true, 'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop');
-- Store 29: Premium Massage Room

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Premium Massage Room', '505 Đường Lê Duẩn', 'Cầu Giấy', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Premium Massage Room, nơi cung cấp các dịch vụ Massage tốt nhất tại Cầu Giấy, Hà Nội.', 'contact29@premiummassageroom.com', '0946410371', 215, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop', 4.2, 'Massage', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.80945100877065, 21.017869718547985), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 963000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 715000, 60, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 725000, 45, true, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Massage Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Massage 1', 'Mô tả dịch vụ chi tiết', 880000, 60, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 2', 'Mô tả dịch vụ chi tiết', 353000, 120, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Massage 3', 'Mô tả dịch vụ chi tiết', 465000, 30, true, 'https://images.unsplash.com/photo-1516975080661-46bce0a149c4?q=80&w=1000&auto=format&fit=crop');
-- Store 30: Urban Makeup Center

    INSERT INTO stores (name, address, district, province, country, introduction, email, phone_number, rating_number, image_url, rating, primary_category, manager_id, store_type, location, is_active)
    VALUES ('Urban Makeup Center', '471 Đường Lê Duẩn', 'Tây Hồ', 'Hà Nội', 'Vietnam', 'Chào mừng bạn đến với Urban Makeup Center, nơi cung cấp các dịch vụ Makeup tốt nhất tại Tây Hồ, Hà Nội.', 'contact30@urbanmakeupcenter.com', '0917881869', 290, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop', 4.4, 'Makeup', '09d83eca-c37e-4d70-a7ca-8eee2a9dc157', 'team', ST_SetSRID(ST_Point(105.83096356201453, 21.019322082313646), 4326), true)
    RETURNING id INTO v_store_id;
  
    INSERT INTO store_working_hours (store_id, day_of_week, start_time, end_time, is_day_off)
    VALUES
    (v_store_id, 2, '08:00:00', '20:00:00', false),
    (v_store_id, 3, '08:00:00', '20:00:00', false),
    (v_store_id, 4, '08:00:00', '20:00:00', false),
    (v_store_id, 5, '08:00:00', '20:00:00', false),
    (v_store_id, 6, '08:00:00', '20:00:00', false),
    (v_store_id, 7, '08:00:00', '20:00:00', false),
    (v_store_id, 8, '08:00:00', '20:00:00', false);
    INSERT INTO store_images (store_id, image_url)
    VALUES
    (v_store_id, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1633681926022-84c23e8cb2d6?q=80&w=1000&auto=format&fit=crop'),
    (v_store_id, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 1', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 508000, 60, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 809000, 45, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 375000, 45, true, 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1000&auto=format&fit=crop');

    INSERT INTO categories (store_id, name, description, is_active)
    VALUES (v_store_id, 'Makeup Category 2', 'Dịch vụ chất lượng cao', true)
    RETURNING id INTO v_category_id;
    
    INSERT INTO services (category_id, name, description, price, duration_minutes, is_active, image_url)
    VALUES
    (v_category_id, 'Dịch vụ Makeup 1', 'Mô tả dịch vụ chi tiết', 172000, 90, true, 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 2', 'Mô tả dịch vụ chi tiết', 997000, 120, true, 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop'),
    (v_category_id, 'Dịch vụ Makeup 3', 'Mô tả dịch vụ chi tiết', 962000, 45, true, 'https://images.unsplash.com/photo-1600948836101-f9ffda59d250?q=80&w=1000&auto=format&fit=crop');
END $$;