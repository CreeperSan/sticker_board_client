
typedef CollectionCombineAction<T> = dynamic Function(int index, T item, dynamic result);

extension CollectionOperationExtension<T> on List<T>{

  dynamic combineAll(CollectionCombineAction<T>  action) {
    dynamic result;
    for(var i=0; i<length; i++){
      T item = this[i];
      result = action.call(i, item, result);
    }
    return result;
  }

}
