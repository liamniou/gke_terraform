import os
import pika
from time import strftime


rabbit_host = os.getenv('RABBIT_HOST', 'localhost')
rabbit_port = os.getenv('RABBIT_PORT', '5672')
rabbit_user = os.getenv('RABBIT_USER', 'admin')
rabbit_password = os.getenv('RABBIT_PASSWORD')

pvc_mount_point = os.getenv('PVC_MOUNT_POINT', '/tmp')


def get_time():
    time = strftime("%Y-%m-%dT%H:%M")
    return time


def write_input_data(message_payload, pvc_mount_point):
    timestamp = get_time()
    full_string = 'DateStamp={}, Name={} \n'.format(timestamp, message_payload)
    data = open('{}/file.log'.format(pvc_mount_point), 'a')
    data.write(full_string)
    data.close()


if __name__ == "__main__":
    credentials = pika.PlainCredentials(rabbit_user, rabbit_password)
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(rabbit_host, rabbit_port, '/', credentials))
    channel = connection.channel()

    channel.queue_declare(queue='main')

    def callback(ch, method, properties, body):
        write_input_data(body, pvc_mount_point)

    channel.basic_consume(
        queue='main', on_message_callback=callback, auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()
