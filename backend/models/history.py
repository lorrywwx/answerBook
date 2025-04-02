#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
答案之书应用 - 历史记录模型

这个模块定义了用户历史记录数据模型。
"""

from datetime import datetime
from . import db


class History(db.Model):
    """历史记录模型"""
    __tablename__ = 'history'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False, comment='用户ID')
    answer_id = db.Column(db.Integer, db.ForeignKey('answers.id'), nullable=False, comment='答案ID')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    
    # 关联答案
    answer = db.relationship('Answer', backref=db.backref('viewed_by', lazy='dynamic'))
    
    def __repr__(self):
        return f'<History: User {self.user_id} - Answer {self.answer_id}>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'answer_id': self.answer_id,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'answer': self.answer.to_dict() if self.answer else None
        }