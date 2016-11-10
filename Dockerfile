FROM python:2.7
ENV PYTHONUNBUFFERED 1
COPY . /app
WORKDIR /app
# dependêcias:
RUN pip install -r /app/requirements.txt
# portas
EXPOSE 8000
USER nobody
CMD gunicorn --workers 3 --bind 0.0.0.0:8000 webapp:app --chdir=/app/flapp --log-level INFO
