#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
答案之书应用 - 分类模型

这个模块定义了答案分类数据模型。
"""

from datetime import datetime
from . import db


class Category(db.Model):
    """分类模型"""
    __tablename__ = 'categories'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(50), unique=True, nullable=False, comment='分类名称')
    description = db.Column(db.String(200), nullable=True, comment='分类描述')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
    is_active = db.Column(db.Boolean, default=True, comment='是否激活')
    
    def __repr__(self):
        return f'<Category: {self.name}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
            'is_active': self.is_active
        }