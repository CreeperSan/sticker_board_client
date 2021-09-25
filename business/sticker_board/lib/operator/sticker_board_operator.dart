
import 'package:log/log.dart';
import 'package:network/network.dart';
import 'package:sticker_board_api/model/sticker_todo_list_model.dart';
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
  void queryStickerList(int page, int pageSize, StickerFilterModel filterModel, {
    void Function(List<StickerModel> stickerList)? onSuccess,
    void Function(int code, String message)? onFail,
  }) {
    // 1. Generate request data
    final Map<String, Object> requestData = {
      'page' : page,
      'page_size' : pageSize,
    };
    if(filterModel.category.isNotEmpty){
      requestData['category'] = filterModel.category;
    }
    if(filterModel.tag.isNotEmpty){
      requestData['tag'] = filterModel.tag;
    }

    // 2. Send network request
    NetworkManager.instance.fetch(URLBuilder.stickerQuery(),
        requestMethod: RequestMethod.Post,
        data: requestData,
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
              final stickerTags = (responseDataItem['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? <String>[];
              final stickerStatus = responseDataItem['status'] ?? StickerStatus.Processing;
              final stickerStar = responseDataItem['star'] ?? 0;
              final stickerIsPinned = responseDataItem['is_pinned'] ?? false;
              final stickerBackground = responseDataItem['background'] ?? '';
              final stickerCreateTime = responseDataItem['create_time'] ?? 0;
              final stickerUpdateTime = responseDataItem['update_time'] ?? 0;
              final stickerCategory = responseDataItem['category'] ?? '';
              final stickerID = responseDataItem['id'] ?? '';
              final stickerTitle = responseDataItem['title'] ?? '';

              switch(itemType){
                case StickerType.PlainText:
                  stickerModelList.add(StickerPlainTextModel(
                    id: stickerID,
                    status: stickerStatus,
                    tags: stickerTags,
                    star: stickerStar,
                    isPinned: stickerIsPinned,
                    background: stickerBackground,
                    createTime: stickerCreateTime,
                    type: itemType,
                    updateTime: stickerUpdateTime,
                    category: stickerCategory,
                    title: stickerTitle,
                    text: responseDataItem['text'] ?? '',
                  ));
                  break;
                case StickerType.PlainImage:
                  stickerModelList.add(StickerPlainImageModel(
                    id: stickerID,
                    status: stickerStatus,
                    tags: stickerTags,
                    star: stickerStar,
                    isPinned: stickerIsPinned,
                    background: stickerBackground,
                    createTime: stickerCreateTime,
                    type: itemType,
                    category: stickerCategory,
                    updateTime: stickerUpdateTime,
                    title: stickerTitle,
                    imagePath: responseDataItem['url'] ?? '',
                    description: responseDataItem['description'] ?? '',
                  ));
                  break;
                case StickerType.PlainSound:
                  stickerModelList.add(StickerPlainSoundModel(
                    id: stickerID,
                    status: stickerStatus,
                    tags: stickerTags,
                    star: stickerStar,
                    isPinned: stickerIsPinned,
                    background: stickerBackground,
                    createTime: stickerCreateTime,
                    category: stickerCategory,
                    type: itemType,
                    updateTime: stickerUpdateTime,
                    title: stickerTitle,
                    url: responseDataItem['url'] ?? '',
                    description: responseDataItem['description'] ?? '',
                    duration: responseDataItem['duration'] ?? 0,
                  ));
                  break;
                case StickerType.TodoList:
                  final todoList = <StickerTodoListItemModel>[];
                  final responseTodoList = responseDataItem['todos'];
                  if(responseTodoList != null && responseTodoList is List){
                    for(var responseTodoItem in responseTodoList){
                      final responseTodoItemState = responseTodoItem['state'];
                      final responseTodoItemMessage = responseTodoItem['message'];
                      final responseTodoItemDescription = responseTodoItem['description'];
                      todoList.add(StickerTodoListItemModel(
                        message: responseTodoItemMessage,
                        state: responseTodoItemState,
                        description: responseTodoItemDescription,
                      ));
                    }
                  }
                  stickerModelList.add(StickerTodoListModel(
                    id: stickerID,
                    status: stickerStatus,
                    tags: stickerTags,
                    star: stickerStar,
                    isPinned: stickerIsPinned,
                    background: stickerBackground,
                    createTime: stickerCreateTime,
                    type: itemType,
                    updateTime: stickerUpdateTime,
                    title: stickerTitle,
                    description: responseDataItem['description'] ?? '',
                    category: stickerCategory,
                    todoList: todoList,
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
