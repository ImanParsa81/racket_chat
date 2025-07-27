# Dockerfile for Zulip

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    libldap2-dev \
    libsasl2-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    postgresql \
    redis-server \
    nginx \
    nodejs \
    npm \
    yarn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create zulip user and directory
RUN useradd -m zulip
WORKDIR /home/zulip

# Clone Zulip source code (replace with the desired version)
RUN git clone https://github.com/zulip/zulip.git
WORKDIR /home/zulip/zulip

# Install Python dependencies
RUN python3 -m venv zulip-venv
RUN . zulip-venv/bin/activate && pip install --upgrade pip setuptools wheel
RUN . zulip-venv/bin/activate && pip install -r requirements.txt

# Build frontend assets
RUN yarn install
RUN yarn build

# Setup Zulip (database migrations, collectstatic, etc.)
RUN . zulip-venv/bin/activate && python manage.py migrate
RUN . zulip-venv/bin/activate && python manage.py collectstatic --noinput

# Expose ports
EXPOSE 80 443

# Start services (adjust according to your init system or use supervisor)
CMD ["zulip-venv/bin/gunicorn", "-c", "zproject/gunicorn.conf.py", "zulip.wsgi:application"]
