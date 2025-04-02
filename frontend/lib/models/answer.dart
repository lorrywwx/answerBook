class Answer {
  final int id;
  final String content;
  final int? categoryId;
  final String? categoryName;
  final String? createdAt;
  final String? updatedAt;
  final bool isActive;
  
  Answer({
    required this.id,
    required this.content,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });
  
  // 从JSON创建答案对象
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      content: json['content'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isActive: json['is_active'] ?? true,
    );
  }
  
  // 将答案对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_active': isActive,
    };
  }
  
  // 创建答案对象的副本
  Answer copyWith({
    int? id,
    String? content,
    int? categoryId,
    String? categoryName,
    String? createdAt,
    String? updatedAt,
    bool? isActive,
  }) {
    return Answer(
      id: id ?? this.id,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}