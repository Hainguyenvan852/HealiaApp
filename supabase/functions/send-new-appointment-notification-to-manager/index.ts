import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import admin from "npm:firebase-admin";
import { createClient } from "npm:@supabase/supabase-js";

const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT") || "{}");
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

serve(async (req) => {
  try {
    const webhookPayload = await req.json();
    const newAppointment = webhookPayload.record;

    const storeId = newAppointment.store_id; 

    if (!storeId) {
      throw new Error("Lịch hẹn không chứa thông tin store_id.");
    }

    const supabaseUrl = Deno.env.get("MY_CLOUD_URL") ?? Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseKey = Deno.env.get("MY_CLOUD_ROLE_KEY") ?? Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

    const supabaseAdmin = createClient(supabaseUrl, supabaseKey);

    const { data: storeData, error: storeError } = await supabaseAdmin
      .from("stores")
      .select("manager_id")
      .eq("id", storeId)
      .single();

    if (storeError || !storeData || !storeData.manager_id) {
      throw new Error(`Không tìm thấy quản lý cho cửa hàng có id: ${storeId}`);
    }

    const targetUserId = storeData.manager_id;

    const { data: settingsData, error: settingsError } = await supabaseAdmin
      .from("user_settings")
      .select("receive_notifications")
      .eq("user_id", targetUserId)
      .single();

    if (settingsData && settingsData.receive_notifications === false) {
      console.log(`User ${targetUserId} đã tắt thông báo. Hủy gửi.`);
      return new Response(JSON.stringify({ 
          message: "Đã hủy gửi do user tắt thông báo" 
      }), { status: 200 }); // Trả về 200 để Webhook biết là xử lý xong,
    } else if (!settingsData || settingsError) {
      console.log(`Không tìm thấy cài đặt cho user ${targetUserId}.`);
    }

    const { data: tokenData, error: tokenError } = await supabaseAdmin
      .from("user_tokens")
      .select("fcm_token")
      .eq("user_id", targetUserId)
      .single();

    if (tokenError || !tokenData || !tokenData.fcm_token) {
      throw new Error(`Không tìm thấy FCM Token cho user: ${targetUserId}`);
    }

    const targetFcmToken = tokenData.fcm_token;

    const title = "💅 Lịch hẹn mới!";
    const body = `Cửa tiệm của bạn vừa nhận một lịch hẹn mới. Hãy mở ứng dụng để kiểm tra chi tiết!`;

    const payload = {
      notification: {
        title: title,
        body: body,
      },
      token: targetFcmToken,
    };

    const response = await admin.messaging().send(payload);

    return new Response(JSON.stringify({ success: true, response }), { 
        headers: { "Content-Type": "application/json" } 
    });

  } catch (error) {
    console.error("Lỗi:", error.message);
    return new Response(JSON.stringify({ error: error.message }), { 
        status: 400,
        headers: { "Content-Type": "application/json" }
    });
  }
})