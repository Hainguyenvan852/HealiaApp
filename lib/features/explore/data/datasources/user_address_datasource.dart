import 'package:healio_app/features/explore/data/models/address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAddressDatasource {
  final SupabaseClient supabaseClient;

  UserAddressDatasource(this.supabaseClient);

  Future<List<AddressModel>> fetchUserAddress(String userId) async{
    try {
      final addresses = await supabaseClient
          .from('user_address')
          .select('*')
          .eq('user_id', userId);

      return addresses.map((addr) => AddressModel.fromJson(addr)).toList();
    } on PostgrestException catch(e){
      throw PostgrestException(message: e.message);
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> insertUserAddress(String userId, AddressModel address) async{
    try {
      await supabaseClient.from('user_address').insert({
        'name': address.name,
        'location': 'POINT(${address.lng} ${address.lat})',
        'address': address.address,
        'user_id': userId,
        'district': address.district,
        'commune': address.commune,
        'province': address.province,
      });
    } on PostgrestException catch(e){
      throw PostgrestException(message: e.message);
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserAddress(AddressModel address) async{
    try {
      await supabaseClient.from('user_address').update({
        'name': address.name,
        //'location': 'POINT(${address.lng} ${address.lat})',
        'address': address.address,
        'district': address.district,
        'commune': address.commune,
        'province': address.province,
        'updated_at' : DateTime.now().toIso8601String()
      })
      .eq('id', address.id);
    } on PostgrestException catch(e){
      throw PostgrestException(message: e.message);
    } catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUserAddress(int addressId) async{
    try {
      await supabaseClient.from('user_address')
        .delete()
        .eq('id', addressId);
    } on PostgrestException catch(e){
      throw PostgrestException(message: e.message);
    } catch(e){
      throw Exception(e.toString());
    }
  }
}