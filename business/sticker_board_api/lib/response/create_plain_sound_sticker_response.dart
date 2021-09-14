
class CreatePlainSoundStickerResponse{
  bool get isSuccess => code == 200;

  int code;
  String message;

  CreatePlainSoundStickerResponse({
    required this.code,
    required this.message,
  });


}
