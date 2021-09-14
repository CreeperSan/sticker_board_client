
import 'package:log/log.dart';
import 'package:network/network.dart';
import 'package:sticker_board_api/sticker_board_api.dart';
import 'package:url_builder/url_builder.dart';

class StickerBoardOperator extends StickerBoardInterface{

  // Singleton Pattern

  StickerBoardOperator._();

  static StickerBoardOperator? _instance;

  static _getInstance(){
    if(_instance == null){
      _instance = StickerBoardOperator._();
    }
    return _instance!;
  }

  factory StickerBoardOperator() => _getInstance();

  static StickerBoardOperator get instance => _getInstance();

  //

  @override
  void queryStickerList(int page, int pageSize, {
    void Function(List<StickerModel> stickerList)? onSuccess,
    void Function(int code, String message)? onFail,
  }) {
    NetworkManager.instance.fetch(URLBuilder.stickerQuery(),
        requestMethod: RequestMethod.Post,
        data: {
          'page' : page,
          'page_size' : pageSize,
        },
        onSuccess: (response){
          // LogManager.d('Get sticker list onSuccess:', this.runtimeType.toString());
          // LogManager.d(response, this.runtimeType.toString());
          // LogManager.d(response.runtimeType, this.runtimeType.toString());
          final code = response['code'] ?? 0;
          final message = response['message'] ?? 'Get stickers fail, please try again later';
          if(code != 200){
            onFail?.call(code, message);
            return;
          }
          List<StickerModel> stickerModelList = [];
          final responseData = response['data'] ?? [];
          if(responseData is List){
            for(dynamic responseDataItem in responseData){
              if(!(responseDataItem is Map)){
                continue;
              }
              final itemType = responseDataItem['type'] ?? StickerType.Unknown;
              switch(itemType){
                case StickerType.PlainText:
                  stickerModelList.add(StickerPlainTextModel(
                      id: responseDataItem['id'] ?? '',
                      status: responseDataItem['status'] ?? StickerStatus.Processing,
                      tags: responseDataItem['tags'] ?? [],
                      star: responseDataItem['star'] ?? 0,
                      isPinned: responseDataItem['is_pinned'] ?? false,
                      background: responseDataItem['background'] ?? '',
                      createTime: responseDataItem['create_time'] ?? 0,
                      type: itemType,
                      updateTime: responseDataItem['update_time'] ?? 0,
                      title: responseDataItem['title'] ?? '',
                      text: responseDataItem['text'] ?? '',
                  ));
                  break;
                case StickerType.PlainImage:
                  stickerModelList.add(StickerPlainImageModel(
                    id: responseDataItem['id'] ?? '',
                    status: responseDataItem['status'] ?? StickerStatus.Processing,
                    tags: responseDataItem['tags'] ?? [],
                    star: responseDataItem['star'] ?? 0,
                    isPinned: responseDataItem['is_pinned'] ?? false,
                    background: responseDataItem['background'] ?? '',
                    createTime: responseDataItem['create_time'] ?? 0,
                    type: itemType,
                    updateTime: responseDataItem['update_time'] ?? 0,
                    title: responseDataItem['title'] ?? '',
                    imagePath: responseDataItem['url'] ?? '',
                    description: responseDataItem['description'] ?? '',
                  ));
                  break;
                case StickerType.PlainSound:
                  stickerModelList.add(StickerPlainSoundModel(
                    id: responseDataItem['id'] ?? '',
                    status: responseDataItem['status'] ?? StickerStatus.Processing,
                    tags: responseDataItem['tags'] ?? [],
                    star: responseDataItem['star'] ?? 0,
                    isPinned: responseDataItem['is_pinned'] ?? false,
                    background: responseDataItem['background'] ?? '',
                    createTime: responseDataItem['create_time'] ?? 0,
                    type: itemType,
                    updateTime: responseDataItem['update_time'] ?? 0,
                    title: responseDataItem['title'] ?? '',
                    url: responseDataItem['url'] ?? '',
                    description: responseDataItem['description'] ?? '',
                    duration: responseDataItem['duration'] ?? 0,
                  ));
                  break;
                default:
                  continue;
              }
            }
          }
          onSuccess?.call(stickerModelList);
        },
        onFail: (error){
          LogManager.d('Get sticker list onFail:', this.runtimeType.toString());
          LogManager.d(error, this.runtimeType.toString());
          onFail?.call(0, 'Connection error, please try again later.');
        }
    );
  }

  @override
  void createStickerPlainImage({
    status = StickerStatus.Processing,
    String category = '',
    List<String> tags = const [],
    int star = 0,
    bool isPinned = false,
    String background = '',
    String title = '',
    String description = '',
    required String imagePath,
    void Function()? onSuccess,
    void Function(int code, String message)? onFail,
  }) {
    NetworkManager.instance.fetch(URLBuilder.stickerCreatePlainImage(),
      requestMethod: RequestMethod.Post,
      data: {
        'star' : star,
        'status' : status,
        'title' : title,
        'background' : background,
        'category_id' : category,
        'tag_id' : tags,
        'is_pinned' : isPinned,
        'description' : description,
        'image_path' : imagePath,
      },
      onSuccess: (response){
        final responseCode = response['code'];
        final responseMessage = response['msg'];
        if(responseCode == 200){
          onSuccess?.call();
        } else {
          onFail?.call(responseCode, responseMessage);
        }
      },
      onFail: (error){
        print(error);
        onFail?.call(0, 'Network error, please check your network connection');
      }
    );
  }

  @override
  Future<CreatePlainSoundStickerResponse> createStickerPlainSound({
    required String soundPath,
    required int duration,
    status = StickerStatus.Processing,
    String category = '',
    List<String> tags = const [],
    int star = 0,
    bool isPinned = false,
    String background = '',
    String title = '',
    String description = '',
  }) async {
    return NetworkManager.instance.rawFetch(URLBuilder.stickerCreatePlainSound(),
      requestMethod: RequestMethod.Post,
      jsonData: {
        'star' : star,
        'status' : status,
        'title' : title,
        'background' : background,
        'category_id' : category,
        'tag_id' : tags,
        'is_pinned' : isPinned,
        'description' : description,
        'path' : soundPath,
        'duration' : duration,
      }
    ).then((value){
      print(value.runtimeType);
      print(value);
      return CreatePlainSoundStickerResponse(
        code: value.data['code'],
        message: value.data['msg'],
      );
    });
  }

}
