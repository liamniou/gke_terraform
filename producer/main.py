import os
import pika
from time import strftime
from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField

DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = 'SjdnUends821Jsdlkvxh391ksdODnejdDw'

rabbit_host = os.getenv('RABBIT_HOST', 'localhost')
rabbit_port = os.getenv('RABBIT_PORT', '5672')
rabbit_user = os.getenv('RABBIT_USER', 'admin')
rabbit_password = os.getenv('RABBIT_PASSWORD')


class ReusableForm(Form):
    name = TextField('Name:', validators=[validators.required()])


def get_time():
    time = strftime("%Y-%m-%dT%H:%M")
    return time


def write_input_data(name):
    timestamp = get_time()
    full_string = 'DateStamp={}, Name={} \n'.format(timestamp, name)
    # data = open('file.log', 'a')
    # data.write(full_string)
    # data.close()
    publish_to_queue(full_string)


def publish_to_queue(message_body):
    credentials = pika.PlainCredentials(rabbit_user, rabbit_password)
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(rabbit_host, rabbit_port, '/', credentials))
    channel = connection.channel()
    channel.queue_declare(queue='main')
    channel.basic_publish(exchange='',
                          routing_key='main',
                          body=message_body)
    connection.close()


@app.route("/", methods=['GET', 'POST'])
def hello():
    form = ReusableForm(request.form)

    #print(form.errors)
    if request.method == 'POST':
        name=request.form['name']

        if form.validate():
            write_input_data(name)
            flash('Hello: {}'.format(name))

        else:
            flash('Error: All Fields are Required')

    return render_template('index.html', form=form)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
