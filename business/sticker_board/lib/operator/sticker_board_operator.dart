
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
          LogManager.d('Get sticker list onSuccess:', this.runtimeType.toString());
          LogManager.d(response, this.runtimeType.toString());
          LogManager.d(response.runtimeType, this.runtimeType.toString());
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
        onFail: (onFail){
          LogManager.d('Get sticker list onFail:', this.runtimeType.toString());
          LogManager.d(onFail, this.runtimeType.toString());
        }
    );
  }

}
