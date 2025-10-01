# Debian
FROM python:3.9

# time
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# certificate
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 && rm -rf /var/lib/apt/lists/*


WORKDIR /app

# install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["bash", "-lc", "gunicorn -k eventlet -w 1 -b 0.0.0.0:${PORT:-8080} app:app --forwarded-allow-ips="*"
"]
