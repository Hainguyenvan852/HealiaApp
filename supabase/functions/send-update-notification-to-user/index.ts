import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import admin from "npm:firebase-admin";
import { createClient } from "npm:@supabase/supabase-js";

// Khởi tạo Firebase
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

    const targetUserId = newAppointment.user_id; 

    if (!targetUserId) {
      throw new Error("Lịch hẹn không chứa thông tin khách hàng.");
    }

    // Khởi tạo supabaseAdmin
    const supabaseUrl = Deno.env.get("MY_CLOUD_URL") ?? Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseKey = Deno.env.get("MY_CLOUD_ROLE_KEY") ?? Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

    const supabaseAdmin = createClient(supabaseUrl, supabaseKey);

    // Bước kiểm tra cài đặt thông báo
    const { data: settingsData, error: settingsError } = await supabaseAdmin
      .from("user_settings")
      .select("receive_notifications")
      .eq("user_id", targetUserId)
      .single();

    if (settingsData && settingsData.receive_notifications === false) {
      console.log(`User ${targetUserId} đã tắt thông báo. Hủy gửi.`);
      return new Response(JSON.stringify({ 
          message: "Đã hủy gửi do user tắt thông báo" 
      }), { status: 200 }); 
    } else if (!settingsData || settingsError) {
      console.log(`Không tìm thấy cài đặt cho user ${targetUserId}.`);
    }

    // Bước lấy Lệnh Bài (FCM Token)
    const { data: tokenData, error: tokenError } = await supabaseAdmin
      .from("user_tokens")
      .select("fcm_token")
      .eq("user_id", targetUserId)
      .single();

    if (tokenError || !tokenData || !tokenData.fcm_token) {
      throw new Error(`Không tìm thấy FCM Token cho user: ${targetUserId}`);
    }

    const targetFcmToken = tokenData.fcm_token;

    // Chế tác nội dung
    const title = "Lịch hẹn của bạn có cập nhật mới! 🔔";
    const body = `Thông tin lịch hẹn của bạn vừa có sự thay đổi. Hãy mở ứng dụng để kiểm tra chi tiết ngay nhé!`;

    const payload = {
      notification: {
        title: title,
        body: body,
      },
      token: targetFcmToken,
    };

    // Vận công gửi đi
    const response = await admin.messaging().send(payload);

    return new Response(JSON.stringify({ success: true, response }), { 
        headers: { "Content-Type": "application/json" } 
    });

  } catch (error: any) {
    console.error("Lỗi:", error.message);
    return new Response(JSON.stringify({ error: error.message }), { 
        status: 400,
        headers: { "Content-Type": "application/json" }
    });
  }
})