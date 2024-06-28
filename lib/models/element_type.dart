enum ElementType {
  collectible,
  post
}

ElementType castElementType(String itemType) {
  switch (itemType.toLowerCase()) {
    case 'post':
      return ElementType.post;
    default:
      return ElementType.collectible;
  }
}