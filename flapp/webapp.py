# coding: utf-8
from flask import Flask
from flask import render_template, flash  # redirect,
from flask_mongoengine import MongoEngine
from flask_wtf import FlaskForm
from wtforms import validators, StringField, TextAreaField

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = MongoEngine(app)


# Models


class Post(db.Document):
    title = db.StringField(max_length=120, required=True, validators=[validators.InputRequired(message=u'Missing title.'), ])
    content = db.StringField()

    def __unicode__(self):
        return self.title


# Forms


class PostForm(FlaskForm):
    title = StringField(u'Titulo')
    content = TextAreaField(u'Conteúdo')


# Views


@app.route('/', methods=('GET', 'POST'))
def home():
    form = PostForm()
    if form.validate_on_submit():
        post = Post(
            title=form.data['title'],
            content=form.data['content'])
        post.save()
        flash(u'form salvo com sucesso!', 'success')
    elif form.errors:
        flash(u'Temos algum erro no form', 'error')

    posts = Post.objects.all()
    context = {
        'form': form,
        'posts': posts,
    }
    return render_template("home.html", **context)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
