const _extMarkdown = 'markdown';
const _extMD = 'md';

bool isMarkdownFileExtension(String extension){
  return [
    _extMarkdown, _extMD,
  ].contains(extension.toLowerCase());
}

