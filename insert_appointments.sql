DO $$
DECLARE
    v_service_id bigint;
    v_price numeric;
    v_app_id bigint;
    v_client_ids bigint[] := '{}';
BEGIN
    -- Get a service from store 34
    SELECT s.id, s.price INTO v_service_id, v_price 
    FROM services s 
    JOIN categories c ON s.category_id = c.id 
    WHERE c.store_id = 34 LIMIT 1;

    IF v_service_id IS NULL THEN
        RAISE EXCEPTION 'No service found for store 34';
    END IF;

    -- Past Appointment 1
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, customer_id, client_id)
    VALUES (34, '2026-05-16T04:46:15.020Z', '2026-05-16T05:46:15.020Z', 'completed', v_price, 'd6f147ac-0085-4e70-830b-e081263a7273', 1)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, customer_id, client_id)
    VALUES (v_app_id, 34, v_price, 'paid', 'cash', 'd6f147ac-0085-4e70-830b-e081263a7273', 1);
    INSERT INTO reviews (store_id, appointment_id, rating, comment, customer_id)
    VALUES (34, v_app_id, 4, 'Dịch vụ rất tốt!', 'd6f147ac-0085-4e70-830b-e081263a7273');

    -- Past Appointment 2
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, customer_id, client_id)
    VALUES (34, '2026-05-27T20:33:47.633Z', '2026-05-27T21:33:47.633Z', 'completed', v_price, 'd6f147ac-0085-4e70-830b-e081263a7273', 1)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, customer_id, client_id)
    VALUES (v_app_id, 34, v_price, 'paid', 'cash', 'd6f147ac-0085-4e70-830b-e081263a7273', 1);
    INSERT INTO reviews (store_id, appointment_id, rating, comment, customer_id)
    VALUES (34, v_app_id, 4, 'Dịch vụ rất tốt!', 'd6f147ac-0085-4e70-830b-e081263a7273');

    -- Past Appointment 3
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, customer_id, client_id)
    VALUES (34, '2026-06-01T17:06:49.772Z', '2026-06-01T18:06:49.772Z', 'completed', v_price, 'd6f147ac-0085-4e70-830b-e081263a7273', 1)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, customer_id, client_id)
    VALUES (v_app_id, 34, v_price, 'paid', 'cash', 'd6f147ac-0085-4e70-830b-e081263a7273', 1);
    INSERT INTO reviews (store_id, appointment_id, rating, comment, customer_id)
    VALUES (34, v_app_id, 5, 'Dịch vụ rất tốt!', 'd6f147ac-0085-4e70-830b-e081263a7273');

    -- Past Appointment 4
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, customer_id, client_id)
    VALUES (34, '2026-05-26T11:35:04.091Z', '2026-05-26T12:35:04.091Z', 'completed', v_price, 'd6f147ac-0085-4e70-830b-e081263a7273', 1)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, customer_id, client_id)
    VALUES (v_app_id, 34, v_price, 'paid', 'cash', 'd6f147ac-0085-4e70-830b-e081263a7273', 1);
    INSERT INTO reviews (store_id, appointment_id, rating, comment, customer_id)
    VALUES (34, v_app_id, 4, 'Dịch vụ rất tốt!', 'd6f147ac-0085-4e70-830b-e081263a7273');

    -- Past Appointment 5
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, customer_id, client_id)
    VALUES (34, '2026-05-14T06:13:42.436Z', '2026-05-14T07:13:42.436Z', 'completed', v_price, 'd6f147ac-0085-4e70-830b-e081263a7273', 1)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, customer_id, client_id)
    VALUES (v_app_id, 34, v_price, 'paid', 'cash', 'd6f147ac-0085-4e70-830b-e081263a7273', 1);
    INSERT INTO reviews (store_id, appointment_id, rating, comment, customer_id)
    VALUES (34, v_app_id, 5, 'Dịch vụ rất tốt!', 'd6f147ac-0085-4e70-830b-e081263a7273');

    -- Insert 5 Clients
    WITH new_client AS (
        INSERT INTO clients (store_id, profile_id, gender, is_active, phone_number, full_name, email)
        VALUES (1, '3e3be0ef-fce1-4f2f-9c14-cbe4ccb8c6be', 1, true, '0912345678', 'Nguyen Van A', 'a@gmail.com')
        RETURNING id
    )
    SELECT array_append(v_client_ids, id) INTO v_client_ids FROM new_client;
    WITH new_client AS (
        INSERT INTO clients (store_id, profile_id, gender, is_active, phone_number, full_name, email)
        VALUES (1, '977444da-b530-46d2-94a5-3cb1b62e1750', 2, true, '0912345679', 'Tran Thi B', 'b@gmail.com')
        RETURNING id
    )
    SELECT array_append(v_client_ids, id) INTO v_client_ids FROM new_client;
    WITH new_client AS (
        INSERT INTO clients (store_id, profile_id, gender, is_active, phone_number, full_name, email)
        VALUES (1, NULL, 1, true, '0912345670', 'Le Van C', 'c@gmail.com')
        RETURNING id
    )
    SELECT array_append(v_client_ids, id) INTO v_client_ids FROM new_client;
    WITH new_client AS (
        INSERT INTO clients (store_id, profile_id, gender, is_active, phone_number, full_name, email)
        VALUES (1, NULL, 2, true, '0912345671', 'Pham Thi D', 'd@gmail.com')
        RETURNING id
    )
    SELECT array_append(v_client_ids, id) INTO v_client_ids FROM new_client;
    WITH new_client AS (
        INSERT INTO clients (store_id, profile_id, gender, is_active, phone_number, full_name, email)
        VALUES (1, NULL, 1, true, '0912345672', 'Hoang Van E', 'e@gmail.com')
        RETURNING id
    )
    SELECT array_append(v_client_ids, id) INTO v_client_ids FROM new_client;

    -- Mixed Appointment 1 for client 1
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-09T07:09:36.414Z', '2026-06-09T08:09:36.414Z', 'confirmed', v_price, v_client_ids[1], '3e3be0ef-fce1-4f2f-9c14-cbe4ccb8c6be')
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[1], '3e3be0ef-fce1-4f2f-9c14-cbe4ccb8c6be');
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 2 for client 2
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-09T13:21:40.004Z', '2026-06-09T14:21:40.004Z', 'confirmed', v_price, v_client_ids[2], '977444da-b530-46d2-94a5-3cb1b62e1750')
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[2], '977444da-b530-46d2-94a5-3cb1b62e1750');
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 3 for client 3
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-02T22:09:10.097Z', '2026-06-02T23:09:10.097Z', 'completed', v_price, v_client_ids[3], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'paid', 'credit_card', v_client_ids[3], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('review', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'Cảm ơn bạn đã sử dụng dịch vụ', 'Hãy để lại đánh giá cho dịch vụ của chúng tôi.');

    -- Mixed Appointment 4 for client 4
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-05T13:18:36.196Z', '2026-06-05T14:18:36.196Z', 'completed', v_price, v_client_ids[4], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'paid', 'credit_card', v_client_ids[4], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('review', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'Cảm ơn bạn đã sử dụng dịch vụ', 'Hãy để lại đánh giá cho dịch vụ của chúng tôi.');

    -- Mixed Appointment 5 for client 5
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-06T13:59:37.550Z', '2026-06-06T14:59:37.550Z', 'confirmed', v_price, v_client_ids[5], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[5], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 6 for client 1
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-08T06:12:35.203Z', '2026-06-08T07:12:35.203Z', 'confirmed', v_price, v_client_ids[1], '3e3be0ef-fce1-4f2f-9c14-cbe4ccb8c6be')
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[1], '3e3be0ef-fce1-4f2f-9c14-cbe4ccb8c6be');
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 7 for client 2
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-09T15:28:54.284Z', '2026-06-09T16:28:54.284Z', 'confirmed', v_price, v_client_ids[2], '977444da-b530-46d2-94a5-3cb1b62e1750')
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[2], '977444da-b530-46d2-94a5-3cb1b62e1750');
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 8 for client 3
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-06T14:51:25.389Z', '2026-06-06T15:51:25.389Z', 'confirmed', v_price, v_client_ids[3], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[3], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 9 for client 4
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-08T21:10:11.390Z', '2026-06-08T22:10:11.390Z', 'confirmed', v_price, v_client_ids[4], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[4], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

    -- Mixed Appointment 10 for client 5
    INSERT INTO appointments (store_id, start_time, end_time, status, total_price, client_id, customer_id)
    VALUES (1, '2026-06-10T05:07:04.915Z', '2026-06-10T06:07:04.915Z', 'confirmed', v_price, v_client_ids[5], NULL)
    RETURNING id INTO v_app_id;
    INSERT INTO appointment_services (appointment_id, service_id) VALUES (v_app_id, v_service_id);
    INSERT INTO transactions (appointment_id, store_id, amount, payment_status, payment_method, client_id, customer_id)
    VALUES (v_app_id, 1, v_price, 'pending', 'credit_card', v_client_ids[5], NULL);
    INSERT INTO notifications (type, user_id, title, content)
    VALUES ('appointment', 'b6ec52be-a43c-4677-a73c-c52bc951c102', 'New appointment available!', 'Bạn có một cuộc hẹn sắp tới tại cửa hàng.');

END $$;