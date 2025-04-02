from flask import Flask, jsonify, request
from flask_cors import CORS
import random
from models.answer import Answer
from models.category import Category
from models.user import User
from models.favorite import Favorite
from models.history import History

app = Flask(__name__)
CORS(app)  # 启用CORS以允许前端访问

# 配置数据库
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# 初始化数据库
from models import init_db, db
init_db(app)

@app.route('/api/answers/random', methods=['GET'])
def get_random_answer():
    try:
        # 使用Answer模型的get_random方法获取随机答案
        answer = Answer.get_random()
        if not answer:
            return jsonify({'error': '没有可用的答案'}), 404
            
        # 记录到历史
        history = History(user_id=1, answer_id=answer.id)
        db.session.add(history)
        db.session.commit()
        return jsonify(answer.to_dict())
    except Exception as e:
        db.session.rollback()
        app.logger.error(f'获取随机答案时发生错误: {str(e)}')
        return jsonify({'error': '服务器内部错误'}), 500
    return jsonify(answer.to_dict())

@app.route('/api/answers/favorite', methods=['POST'])
def favorite_answer():
    data = request.json
    answer_id = data.get('answer_id')
    user_id = data.get('user_id', 1)  # 默认用户ID为1
    
    # 检查答案是否存在
    answer = Answer.query.get(answer_id)
    if not answer:
        return jsonify({'success': False, 'message': '答案不存在'}), 404
        
    # 添加到收藏
    favorite = Favorite(user_id=user_id, answer_id=answer_id)
    db.session.add(favorite)
    db.session.commit()
    
    return jsonify({'success': True, 'message': '收藏成功'})

@app.route('/api/favorites', methods=['GET'])
def get_favorites():
    user_id = request.args.get('user_id', 1, type=int)  # 默认用户ID为1
    
    # 获取用户的收藏
    user_favorites = Favorite.query.filter_by(user_id=user_id).all()
    
    # 获取收藏的答案详情
    favorite_answers = [{
        'favorite_id': fav.id,
        'answer': Answer.query.get(fav.answer_id).to_dict()
    } for fav in user_favorites if Answer.query.get(fav.answer_id)]
    
    return jsonify(favorite_answers)

@app.route('/api/history', methods=['GET'])
def get_history():
    user_id = request.args.get('user_id', 1, type=int)  # 默认用户ID为1
    
    # 获取用户的历史记录
    user_history = History.query.filter_by(user_id=user_id).all()
    
    # 获取历史记录的答案详情
    history_answers = [{
        'history_id': hist.id,
        'timestamp': hist.created_at,
        'answer': Answer.query.get(hist.answer_id).to_dict()
    } for hist in user_history if Answer.query.get(hist.answer_id)]
    
    return jsonify(history_answers)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)