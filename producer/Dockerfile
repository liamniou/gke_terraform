FROM python:3.7
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN mkdir templates
COPY main.py ./
COPY index.html ./templates
CMD [ "python", "./main.py" ]